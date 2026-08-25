resource "aws_db_subnet_group" "mysql" {
  name = "terraform-mysql-subnet-group"

  subnet_ids = [
    var.private_subnet_a_id,
    var.private_subnet_b_id
  ]

  tags = {
    Name        = "Terraform-MySQL-Subnet-Group"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

# =========================================================
# RDS MYSQL
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

  port = 3306

  db_subnet_group_name = aws_db_subnet_group.mysql.name

  vpc_security_group_ids = [
    var.rds_sg_id
  ]

  publicly_accessible = false

  multi_az = false

  backup_retention_period = 0

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