# =========================================================
# VPC MODULE
# =========================================================

module "vpc" {
  source = "./modules/vpc"

  aws_region = var.aws_region

  vpc_cidr = var.vpc_cidr

  public_subnet_a_cidr = var.public_subnet_a_cidr
  public_subnet_b_cidr = var.public_subnet_b_cidr

  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
}


# =========================================================
# SECURITY GROUP MODULE
# =========================================================

module "security_groups" {
  source = "./modules/security_groups"

  vpc_id = module.vpc.vpc_id
}


# =========================================================
# EC2 WEB TIER
# =========================================================

module "ec2" {
  source = "./modules/ec2"

  aws_region = var.aws_region

  ec2_instance_count = var.ec2_instance_count

  ami_id        = var.ami_id
  instance_type = var.instance_type

  public_subnet_a_id = module.vpc.public_subnet_a_id
  public_subnet_b_id = module.vpc.public_subnet_b_id

  web_sg_id = module.security_groups.web_sg_id
}


# =========================================================
# APPLICATION LOAD BALANCER
# =========================================================

module "alb" {
  source = "./modules/alb"

  vpc_id = module.vpc.vpc_id

  alb_sg_id = module.security_groups.alb_sg_id

  public_subnet_a_id = module.vpc.public_subnet_a_id
  public_subnet_b_id = module.vpc.public_subnet_b_id

  instance_ids = module.ec2.instance_ids
}


# =========================================================
# RDS MYSQL
# =========================================================

module "rds" {
  source = "./modules/rds"

  private_subnet_a_id = module.vpc.private_subnet_a_id
  private_subnet_b_id = module.vpc.private_subnet_b_id

  rds_sg_id = module.security_groups.rds_sg_id

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  db_instance_class = var.db_instance_class
}


# =========================================================
# S3
# =========================================================

module "s3" {
  source = "./modules/s3"

  aws_region = var.aws_region

  buckets = var.s3_buckets
}