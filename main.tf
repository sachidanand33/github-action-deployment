resource "aws_instance" "web" {

  ami = "ami-00d2dbb426772b03a"

  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-OIDC-EC2_04"
  }
}


# S3 bucket names
locals {
  buckets = {
    logs    = "terraform-logs"
    backup  = "terraform-backup"
    data    = "terraform-data"
    archive = "terraform-archive"
  }
}


# Generate a unique random suffix for each bucket
resource "random_id" "bucket_suffix" {

  for_each = local.buckets

  byte_length = 4
}


# Create 4 S3 buckets
resource "aws_s3_bucket" "buckets" {

  for_each = local.buckets

  bucket = "${each.value}-${random_id.bucket_suffix[each.key].hex}"

  tags = {
    Name        = each.value
    Environment = "non-prod"
  }
}