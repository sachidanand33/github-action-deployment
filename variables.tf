variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "Public subnet A CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "Public subnet B CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_a_cidr" {
  description = "Private subnet A CIDR for RDS"
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_subnet_b_cidr" {
  description = "Private subnet B CIDR for RDS"
  type        = string
  default     = "10.0.12.0/24"
}

variable "ec2_instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Amazon Linux AMI ID"
  type        = string
  default     = "ami-0ac7b260cf76d8865"
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "terraformdb"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

# s3 count
variable "s3_buckets" {
  description = "S3 buckets to create"
  type        = map(string)

  default = {
    logs    = "terraform-logs"
    backup  = "terraform-backup"
    data    = "terraform-data"
    archive = "terraform-archive"
  }
}