
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-south-1"
}

# instance count
variable "ec2_count" {
  description = "Number of EC2 web servers"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ec2_ami" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0ac7b260cf76d8865"
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