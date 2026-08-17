
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

# instance count
variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 4
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