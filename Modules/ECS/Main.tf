# ============== IAM Roles and Policies ============== #

# "IAM role" for "ECS Task Execution #1":
resource "aws_iam_role" "task_role_1" {
  name = "ecs-execution-role-1"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

# "IAM role" for "ECS Task Execution #2":
resource "aws_iam_role" "task_role_2" {
  name = "ecs-execution-role-2"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

# "IAM Policy" for "ECS Task Execution":
resource "aws_iam_policy" "task_policy" {
  name = "ecs-execution-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : ""
      }
    ]
  })
}

# Attach "Execution Policy" to "Execution Role":
resource "aws_iam_role_policy_attachment" "policy_exec_role" {
  role       = aws_iam_role.task_role_1.name
  policy_arn = aws_iam_policy.task_policy.arn
}

# "IAM Role" for "ECS Tasks" with additional permissions:
resource "aws_iam_role" "task_role_3" {
  name = "ecs-task-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# "IAM Policy" for "ECS Tasks":
resource "aws_iam_policy" "task_role_4" {
  name = "ecs-task-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "ssmmessages:OpenDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:CreateControlChannel"
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : ""
      }
    ]
  })
}

# Attach "Task Policy" to "Task Role":
resource "aws_iam_role_policy_attachment" "policy_task_role" {
  role       = aws_iam_role.task_role_3.name
  policy_arn = aws_iam_policy.task_role_4.arn
}

# ================= Secrets Manager ================== #

# "Secrets Manager" with "Database" credentials:
data "aws_secretsmanager_secret" "secret_manager_db" {
  arn = var.secret_manager_db_arn
}

# ================== Security Group ================== #

# "Security Group" for "ECS Tasks" allowing Inbound Traffic:
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Allow Inbound Traffic for ECS Tasks"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ========= Load Balancer and Target Groups ========== #

# "Application Load Balancer" (ALB) configuration:
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets = [
    var.subnet_web_id,
  var.subnet_alb_id]
}

# "Target Group" for "app-web":
resource "aws_lb_target_group" "app_web" {
  name        = "app-web-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path = "/"
    port = "traffic-port"
  }
}

# "Target Group" for "app-api":
resource "aws_lb_target_group" "app_api" {
  name        = "app-api-tg"
  port        = 4000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path = "/"
    port = "traffic-port"
  }
}

# "Listener" for "Load Balancer" and redirect "HTTP" to "HTTPS":
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# "Listener Rule" for "app-api":
resource "aws_lb_listener_rule" "app_api" {
  listener_arn = aws_lb_listener.lb_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_api.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}

# "Listener Rule" for "app-web":
resource "aws_lb_listener_rule" "app_web" {
  listener_arn = aws_lb_listener.lb_listener.arn
  priority     = 90

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_web.arn
  }

  condition {
    path_pattern {
      values = ["/web/*"]
    }
  }
}

# =============== ECS Task Definitions =============== #

# "Task Definition" for "app-web":
resource "aws_ecs_task_definition" "app_web" {
  family                   = "app-web"
  execution_role_arn       = aws_iam_role.task_role_1.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.task_role_2.arn
  cpu                      = "512"
  memory                   = "1024"
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "app-web",
    "image": "docker.io/jondaw/app-web",
    "cpu": 512,
    "memory": 1024,
    "portMappings": [
      {
        "containerPort": 4000,
        "hostPort": 3000,
        "protocol": "tcp"
      }
    ],
    "essential": true,
    "environment": [
      {
        "name": "DB_HOST",
        "value": "${data.aws_secretsmanager_secret.secret_manager_db.arn}:host"
      },
      {
        "name": "DB_NAME",
        "value": "${data.aws_secretsmanager_secret.secret_manager_db.arn}:db_name"
      },
      {
        "name": "DB_USER",
        "value": "value": "${data.aws_secretsmanager_secret.secret_manager_db.arn}:user"
      },
      {
        "name": "DB_PASSWORD",
        "value": "${data.aws_secretsmanager_secret.secret_manager_db.arn}:password"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/app-web",
        "awslogs-create-group": "true",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
TASK_DEFINITION
}

# "Task Definition" for "app-api":
resource "aws_ecs_task_definition" "app_api" {
  family                   = "app-api"
  execution_role_arn       = aws_iam_role.task_role_1.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.task_role_2.arn
  cpu                      = "512"
  memory                   = "1024"
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "app-api",
    "image": "docker.io/jondaw/app-api",
    "cpu": 512,
    "memory": 1024,
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000,
        "protocol": "tcp"
      }
    ],
    "essential": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/app-api",
        "awslogs-create-group": "true",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
TASK_DEFINITION
}

# =================== ECS Services =================== #

# "ECS Service" for "app-web":
resource "aws_ecs_service" "app_web" {
  name            = "app-web"
  cluster         = "toptal"
  task_definition = aws_ecs_task_definition.app_web.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    assign_public_ip = true
    subnets          = [var.subnet_web_id]
    security_groups  = [aws_security_group.ecs_sg.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.app_web.arn
    container_name   = "app-web"
    container_port   = 4000
  }
  depends_on = [
    aws_lb_listener.lb_listener,
    aws_lb_listener_rule.app_api,
    aws_lb_listener_rule.app_web
  ]
}

# "ECS Service" for "app-api":
resource "aws_ecs_service" "app_api" {
  name            = "app-api"
  cluster         = "toptal"
  task_definition = aws_ecs_task_definition.app_api.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    assign_public_ip = false
    subnets          = [var.subnet_api_id]
    security_groups  = [aws_security_group.ecs_sg.id]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.app_api.arn
    container_name   = "app-api"
    container_port   = 3000
  }
  depends_on = [
    aws_lb_listener.lb_listener,
    aws_lb_listener_rule.app_api
  ]
}

# ==================================================== #