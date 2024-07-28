# ==================================================== #

# "Security Group" - Allow connect to "HTTP" and "SSH"
resource "aws_security_group" "sec_group_vpc" {
  name        = "sec-group-vpc"
  description = "Allow incoming HTTP Connections"
  vpc_id      = aws_vpc.main.id

  # "HTTP"
  ingress {
    description = "Allow incoming HTTP for redirect to HTTPS"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # "HTTPS"
  ingress {
    description = "Allow incoming HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # "SSH"
  ingress {
    description = "Allow SSH from only our VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow all "Outbound Traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ==================================================== #