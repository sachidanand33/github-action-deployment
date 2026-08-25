# =========================================================
# ALB SECURITY GROUP
# =========================================================

resource "aws_security_group" "alb_sg" {
  name        = "terraform-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Terraform-ALB-SG"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

# =========================================================
# WEB / EC2 SECURITY GROUP
# =========================================================

resource "aws_security_group" "web_sg" {
  name        = "terraform-nginx-web-sg"
  description = "Security group for Web EC2 instances"
  vpc_id      = var.vpc_id

  # Temporary SSH access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP only from ALB
  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Terraform-Nginx-SG"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

# =========================================================
# RDS SECURITY GROUP
# =========================================================

resource "aws_security_group" "rds_sg" {
  name        = "terraform-rds-sg"
  description = "Security group for RDS MySQL"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Terraform-RDS-SG"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}