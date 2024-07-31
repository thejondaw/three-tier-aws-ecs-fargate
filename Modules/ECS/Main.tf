# ==================== ECS MODULE ==================== #

# "ECS Cluster"
resource "aws_ecs_cluster" "main" {
  name = "nyan-cat"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ================ IAM ROLES & POLICY ================ #

# "IAM Role" for "ECS Task Execution"
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"
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

# Attach "Policy" to "ECS Execution Role"
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

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

# ========== LOAD BALANCERS & TARGET GROUPS ========== #

# ----------------- API APPLICATION ------------------ #

# "Application Load Balancer" (ALB) for "API" Application
resource "aws_lb" "api" {
  name               = "api-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api_alb.id]
  subnets            = [data.aws_subnet.api_1.id, data.aws_subnet.api_2.id]
}

# "LB" "Target Group" for "API" Application
resource "aws_lb_target_group" "api" {
  name        = "api-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/api/status"
    port                = "traffic-port" # MAYBE DELETE
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200"
  }
}

# "Listener" for "API" "ALB"
resource "aws_lb_listener" "api" {
  load_balancer_arn = aws_lb.api.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No matching route"
      status_code  = "404"
    }
  }
}

# "Listener Rule" for "API" Application
resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.api.arn
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

# ----------------- WEB APPLICATION ------------------ #

# "Application Load Balancer" (ALB) for "WEB" Application
resource "aws_lb" "web" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_alb.id]
  subnets            = [data.aws_subnet.web_1.id, data.aws_subnet.web_2.id]
}

# "LB" "Target Group" for "WEB" Application
resource "aws_lb_target_group" "web" {
  name        = "web-tg"
  port        = 4000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/"
    port                = "traffic-port" # MAYBE DELETE
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 30
    interval            = 60
    matcher             = "200"
  }
}

# "Listener" for "WEB" "ALB"
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = 4000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# "Listener Rule" for "WEB" Application
resource "aws_lb_listener_rule" "web" {
  listener_arn = aws_lb_listener.web.arn
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

# ================= SECURITY GROUPS ================== #

# Allow "Inbound Traffic" on "3000" & "4000" from ALBs & all "Outbound Traffic"
resource "aws_security_group" "ecs_tasks" {
  name        = "ecs-tasks-sg"
  description = "Allow Inbound Traffic for ECS Tasks"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.api_alb.id]
  }

  ingress {
    from_port       = 4000
    to_port         = 4000
    protocol        = "tcp"
    security_groups = [aws_security_group.web_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allow "Inbound (HTTP) Traffic" & all "Outbound Traffic" for "API ALB"
resource "aws_security_group" "api_alb" {
  name        = "api-alb-sg"
  description = "Allow Inbound Traffic for API ALB"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port   = 3000
    to_port     = 3000
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

# Allows Inbound (HTTP) Traffic & all Outbound Traffic for "WEB ALB"
resource "aws_security_group" "web_alb" {
  name        = "web-alb-sg"
  description = "Allow Inbound Traffic for WEB ALB"
  vpc_id      = data.aws_vpc.main.id

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
      image = "docker.io/jondaw/app-api:latest"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      environment = [
        {
          name  = "DBHOST"
          value = data.aws_rds_cluster.aurora_postgresql.endpoint
        },
        {
          name  = "DBPORT"
          value = tostring(data.aws_rds_cluster.aurora_postgresql.port)
        },
        {
          name  = "DB"
          value = data.aws_rds_cluster.aurora_postgresql.database_name
        },
        {
          name  = "DBUSER"
          value = data.aws_rds_cluster.aurora_postgresql.master_username
        },
        {
          name  = "DBPASS"
          value = "password"
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
      image = "docker.io/jondaw/app-web:latest"
      portMappings = [
        {
          containerPort = 4000
          hostPort      = 4000
        }
      ]
      environment = [
        {
          name  = "API_HOST"
          value = "http://${aws_lb.api.dns_name}"
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
}

# =================== ECS SERVICES =================== #

# "ECS Service" for "API" Application
resource "aws_ecs_service" "api" {
  name            = "api-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [data.aws_subnet.api_1.id, data.aws_subnet.api_2.id]
    security_groups  = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = "api-app"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.api]
}

# "ECS Service" for "WEB" Application
resource "aws_ecs_service" "web" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [data.aws_subnet.web_1.id, data.aws_subnet.web_2.id]
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web.arn
    container_name   = "web-app"
    container_port   = 4000
  }

  depends_on = [aws_lb_listener.web]
}

# =================== AUTO-SCALING =================== #

# "Auto-Scaling Target" for "API" Application
resource "aws_appautoscaling_target" "api" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.api.name}"
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

# "Auto-Scaling Target" for "WEB" Application
resource "aws_appautoscaling_target" "web" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.web.name}"
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

# ==================================================== #