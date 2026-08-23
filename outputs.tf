# ---------------------------------------------------------
# Multiple EC2 Outputs
# ---------------------------------------------------------
output "instance_ids" {
  description = "IDs of all EC2 instances"
  value       = aws_instance.web[*].id
}

output "instance_private_ips" {
  description = "Private IP addresses of all EC2 instances"
  value       = aws_instance.web[*].private_ip
}


output "instance_public_ips" {
  description = "Public IP addresses of all EC2 instances"
  value       = aws_instance.web[*].public_ip
}

output "instance_names" {
  description = "Names of all EC2 instances"
  value       = aws_instance.web[*].tags["Name"]
}

output "nginx_urls" {
  description = "Nginx URLs for all EC2 instances"
  value = [
    for instance in aws_instance.web :
    "http://${instance.public_ip}"
  ]
}

output "ec2_file_path" {
  description = "File created on each EC2 instance"
  value = [
    for instance in aws_instance.web :
    "/home/ec2-user/terraform-file.txt"
  ]
}

# multiple s3 output
output "s3_bucket_names" {
  value = {
    for key, bucket in aws_s3_bucket.buckets :
    key => bucket.bucket
  }
}


output "s3_file_names" {
  description = "File created in each S3 bucket"
  value = {
    for key, object in aws_s3_object.bucket_file :
    key => object.key
  }
}

output "s3_file_locations" {
  description = "S3 locations of the Terraform files"
  value = {
    for key, object in aws_s3_object.bucket_file :
    key => "s3://${object.bucket}/${object.key}"
  }
}

# ---------------------------------------------------------
# VPC Outputs
# ---------------------------------------------------------

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

output "vpc_cidr" {
  description = "CIDR block of the Terraform VPC"
  value       = aws_vpc.main.cidr_block
}


# ---------------------------------------------------------
# Subnet Outputs
# ---------------------------------------------------------

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "public_subnet_cidr" {
  description = "CIDR block of the public subnet"
  value       = aws_subnet.public.cidr_block
}


# ---------------------------------------------------------
# Security Group Output
# ---------------------------------------------------------

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.web_sg.id
}

# ---------------------------------------------------------
# ALB Outputs
# ---------------------------------------------------------

output "alb_id" {
  description = "Application Load Balancer ID"
  value       = aws_lb.web_alb.id
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.web_alb.dns_name
}

output "alb_url" {
  description = "Application Load Balancer URL"
  value       = "http://${aws_lb.web_alb.dns_name}"
}

output "target_group_arn" {
  description = "Web target group ARN"
  value       = aws_lb_target_group.web_tg.arn
}