# ==================== ECS MODULE ==================== #

# "ECS Cluster" with "Container Insights" "Enabled"
resource "aws_ecs_cluster" "main" {
  name = "nyan-cat"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# =============== IAM ROLE & POLICIES ================ #

# "IAM Role" for "ECS Task Execution"
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach "AmazonECSTaskExecutionRolePolicy" to created "Role"
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ================= SECURITY GROUPS ================== #

# "Security Group" for "ECS Tasks"
resource "aws_security_group" "ecs_tasks" {
  name        = "ecs-tasks-sg"
  description = "Allow Inbound Traffic to ECS Tasks"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = 3000
    to_port         = 3000
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 4000
    to_port         = 4000
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# "Security Group" for "Application Load Balancer" (ALB)
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Allow Inbound Traffic to ALB"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

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

# ============== TASK DEFINITION - API =============== #

# Define an "ECS Task" for "API" Application
resource "aws_ecs_task_definition" "api" {
  family                   = "app-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "app-api"
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
        }
      ]
      secrets = [
        {
          name      = "DBPASS"
          valueFrom = "password"
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

# ============== TASK DEFINITION - WEB =============== #

# Define an "ECS Task" for "WEB" Application
resource "aws_ecs_task_definition" "web" {
  family                   = "app-web"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "app-web"
      image = "docker.io/jondaw/app-web:latest"
      portMappings = [
        {
          containerPort = 4000
          hostPort      = 3000
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

# ================== LOAD BALANCERS ================== #

# "Application Load Balancer" for "API" Application
resource "aws_lb" "api" {
  name               = "api-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [data.aws_subnet.api_1.id, data.aws_subnet.api_2.id]
}

# "Application Load Balancer" for "WEB" Application
resource "aws_lb" "web" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [data.aws_subnet.web_1.id, data.aws_subnet.web_1.id]
}

# "ALB Listener" for "API" "Target Group"
resource "aws_lb_listener" "api" {
  load_balancer_arn = aws_lb.api.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

# "ALB Listener" for "WEB" "Target Group"
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# "ALB Target Group" for "API" Application
resource "aws_lb_target_group" "api" {
  name        = "api-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/api/status"
    unhealthy_threshold = "2"
  }
}

# "ALB Target Group" for "WEB" Application
resource "aws_lb_target_group" "web" {
  name        = "web-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
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
    subnets         = [data.aws_subnet.api_1.id, data.aws_subnet.api_2.id]
    security_groups = [aws_security_group.ecs_tasks.id, data.aws_security_group.sg_aurora.id]
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
    subnets         = [data.aws_subnet.web_1.id, data.aws_subnet.web_2.id]
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web.arn
    container_name   = "web-app"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.web]
}

# =================== AUTO SCALING =================== #

# Set up "Target" "Auto-Scaling" for "API Service"
resource "aws_appautoscaling_target" "api" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.api.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Configure "Auto-Scaling Policy" for "API Service" based on "CPU" usage
resource "aws_appautoscaling_policy" "api_cpu" {
  name               = "api-cpu-autoscaling"
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

# Set up "Target" "Auto-Scaling" for "WEB Service"
resource "aws_appautoscaling_target" "web" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.web.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Configure "Auto-Scaling Policy" for "WEB Service" based on "CPU" usage
resource "aws_appautoscaling_policy" "web_cpu" {
  name               = "web-cpu-autoscaling"
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

# ==================================================== #