# MySQL access to RDS
egress {
  description = "Allow outbound traffic"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

tags = {
  Name = "Terraform-Nginx-SG"
}

# =========================================================
# RDS SECURITY GROUP
# =========================================================

resource "aws_security_group" "rds_sg" {
  name        = "terraform-rds-sg"
  description = "Security group for RDS MySQL"
  vpc_id      = aws_vpc.main.id

  # MySQL ONLY from EC2 security group
  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  # RDS outbound
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-RDS-SG"
  }
}

# =========================================================
# RDS SUBNET GROUP
# =========================================================

resource "aws_db_subnet_group" "mysql" {
  name = "terraform-mysql-subnet-group"

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = {
    Name        = "Terraform-MySQL-Subnet-Group"
    Environment = "prod"
  }
}


# =========================================================
# RDS MYSQL DATABASE
# =========================================================

resource "aws_db_instance" "mysql" {
  identifier = "terraform-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = var.db_instance_class

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 3306

  db_subnet_group_name = aws_db_subnet_group.mysql.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  publicly_accessible = false

  multi_az = false

  backup_retention_period = 7

  backup_window = "03:00-04:00"

  maintenance_window = "sun:04:00-sun:05:00"

  skip_final_snapshot = true

  deletion_protection = false

  storage_encrypted = true

  auto_minor_version_upgrade = true

  tags = {
    Name        = "Terraform-MySQL"
    Environment = "prod"
    Tier        = "Database"
    ManagedBy   = "Terraform"
  }
}