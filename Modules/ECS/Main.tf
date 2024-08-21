# ==================== ECS MODULE ==================== #

# "ECS Cluster"
resource "aws_ecs_cluster" "project_cluster" {
  name = "project-cluster" #! VARS

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ================ IAM ROLES & POLICY ================ #

# "IAM Role" for "ECS Tasks"
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

# "IAM Role" for "ECS Task Execution"
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

# "IAM Role Policy" for permission to read "Secret Manager"
resource "aws_iam_role_policy" "ecs_task_execution_role_policy" {
  name = "ecs-task-execution-role-policy"
  role = aws_iam_role.ecs_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "kms:Decrypt"
        ]
        Resource = [data.aws_secretsmanager_secret.secret_manager_rds.arn]
      }
    ]
  })
}

# Attach "Policy" to "ECS Execution Role"
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ========== LOAD BALANCERS & TARGET GROUPS ========== #

# "Application Load Balancer" (ALB) for "WEB" & "API" Applications
resource "aws_lb" "project_alb" {
  name               = "project-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sec_group_ecs.id]
  subnets            = [
    data.aws_subnet.web_1.id,
    data.aws_subnet.web_2.id,
    data.aws_subnet.web_3.id
    ]
}

# ----- ----- ----- ----- ----- ----- ----- ----- ---- #

# "Listener" for "ALB"
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.project_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# "Listener Rule" for "API" Application
resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}

# "Listener Rule" for "WEB" Application
resource "aws_lb_listener_rule" "web" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 90

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }

  condition {
    path_pattern {
      values = ["/web/*"]
    }
  }
}

# ----- ----- ----- ----- ----- ----- ----- ----- ---- #

# "Target Group" for "API" Application
resource "aws_lb_target_group" "api" {
  name        = "api-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/api/status"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200"
  }
}

# "Target Group" for "WEB" Application
resource "aws_lb_target_group" "web" {
  name        = "web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 30
    interval            = 60
    matcher             = "200"
  }
}

# ================= SECURITY GROUPS ================== #

# "Security Group" for "ECS Tasks"
resource "aws_security_group" "sec_group_ecs" {
  description = "Main security group for ALB and ECS Tasks"
  name        = "sec-group-ecs"
  vpc_id      = data.aws_vpc.main.id

  # "Incoming" Traffic for "API"
  ingress {
    description = "Allow Incoming Traffic for API from ALB"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    self        = true
  }

  # "Incoming" Traffic for "WEB"
  ingress {
    description = "Allow Incoming Traffic for WEB from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = true
  }

    # "Incoming" "HTTP" Traffic for "ALB"
  ingress {
    description = "Allow Incoming HTTP Traffic for ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # "Outgoing" Traffic to "Database"
  egress {
    description = "Allow Outbound Traffic to Database"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]

  }

  # Allow all "Outbound Traffic"
  egress {
    description = "Allow all Outbound Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ================= TASK DEFINITIONS ================= #

# Define "ECS Task "for "API" Application
resource "aws_ecs_task_definition" "api" {
  family                   = "api-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "api-app"
      image = "${data.aws_ecr_repository.api.repository_url}:${var.docker_image_tag}"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      secrets = [
        {
          name      = "DBHOST"
          valueFrom = "${data.aws_secretsmanager_secret.aurora_secret.arn}:host::"
        },
        {
          name      = "DBPORT"
          valueFrom = "${data.aws_secretsmanager_secret.aurora_secret.arn}:port::"
        },
        {
          name      = "DB"
          valueFrom = "${data.aws_secretsmanager_secret.aurora_secret.arn}:dbname::"
        },
        {
          name      = "DBUSER"
          valueFrom = "${data.aws_secretsmanager_secret.aurora_secret.arn}:username::"
        },
        {
          name      = "DBPASS"
          valueFrom = "${data.aws_secretsmanager_secret.aurora_secret.arn}:password::"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.api.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "api"
        }
      }
    }
  ])

  depends_on = [null_resource.docker_build_push]
}

# Define "ECS Task" for "WEB" Application
resource "aws_ecs_task_definition" "web" {
  family                   = "web-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "web-app"
      image = "${data.aws_ecr_repository.web.repository_url}:${var.docker_image_tag}"
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = [
        {
          name  = "API_HOST"
          value = "http://${aws_lb.main.dns_name}"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.web.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "web"
        }
      }
    }
  ])

  depends_on = [null_resource.docker_build_push]
}

# =================== ECS SERVICES =================== #

# "ECS Service" for "API" Application
resource "aws_ecs_service" "api" {
  name            = "api-service"
  cluster         = aws_ecs_cluster.project_cluster.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [
      data.aws_subnet.db_1.id,
      data.aws_subnet.db_2.id,
      data.aws_subnet.db_3.id
      ]
    security_groups  = [aws_security_group.sec_group_ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = "api-app"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.front_end]
}

# "ECS Service" for "WEB" Application
resource "aws_ecs_service" "web" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.project_cluster.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [
      data.aws_subnet.web_1.id,
      data.aws_subnet.web_2.id,
      data.aws_subnet.web_3.id
      ]
    security_groups  = [aws_security_group.sec_group_ecs.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web.arn
    container_name   = "web-app"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.front_end]
}

# =================== AUTO-SCALING =================== #

# "Auto-Scaling Target" for "API" Application
resource "aws_appautoscaling_target" "api" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.project_cluster.name}/${aws_ecs_service.api.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# "Auto-Scaling Policy" for "API" Application
resource "aws_appautoscaling_policy" "api_cpu" {
  name               = "api-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.api.resource_id
  scalable_dimension = aws_appautoscaling_target.api.scalable_dimension
  service_namespace  = aws_appautoscaling_target.api.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 60.0
  }
}

# ----- ----- ----- ----- ----- ----- ----- ----- ---- #

# "Auto-Scaling Target" for "WEB" Application
resource "aws_appautoscaling_target" "web" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.project_cluster.name}/${aws_ecs_service.web.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# "Auto-Scaling Policy" for "WEB" Application
resource "aws_appautoscaling_policy" "web_cpu" {
  name               = "web-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.web.resource_id
  scalable_dimension = aws_appautoscaling_target.web.scalable_dimension
  service_namespace  = aws_appautoscaling_target.web.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 60.0
  }
}

# ============== CLOUDWATCH LOG GROUPS =============== #

# "CloudWatch" "Log Group" for "API" Application
resource "aws_cloudwatch_log_group" "api" {
  name              = "/ecs/api-app"
  retention_in_days = 30
}

# "CloudWatch" "Log Group" for "WEB" Application
resource "aws_cloudwatch_log_group" "web" {
  name              = "/ecs/web-app"
  retention_in_days = 30
}
