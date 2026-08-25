# =========================================================
# VPC
# =========================================================

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}


# =========================================================
# SUBNETS
# =========================================================

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}


# =========================================================
# EC2
# =========================================================

output "instance_ids" {
  value = module.ec2.instance_ids
}

output "instance_private_ips" {
  value = module.ec2.private_ips
}

output "instance_public_ips" {
  value = module.ec2.public_ips
}

output "instance_availability_zones" {
  value = module.ec2.availability_zones
}

output "instance_subnet_ids" {
  value = module.ec2.subnet_ids
}

output "instance_names" {
  value = module.ec2.instance_names
}


# =========================================================
# ALB
# =========================================================

output "alb_id" {
  value = module.alb.alb_id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_url" {
  value = module.alb.alb_url
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}


# =========================================================
# RDS
# =========================================================

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "rds_address" {
  value = module.rds.rds_address
}

output "rds_port" {
  value = module.rds.rds_port
}

output "rds_database_name" {
  value = module.rds.rds_database_name
}


# =========================================================
# S3
# =========================================================

output "s3_bucket_names" {
  value = module.s3.bucket_names
}

output "s3_file_names" {
  value = module.s3.file_names
}

output "s3_file_locations" {
  value = module.s3.file_locations
}


# =========================================================
# SECURITY GROUPS
# =========================================================

output "alb_security_group_id" {
  value = module.security_groups.alb_sg_id
}

output "web_security_group_id" {
  value = module.security_groups.web_sg_id
}

output "rds_security_group_id" {
  value = module.security_groups.rds_sg_id
}