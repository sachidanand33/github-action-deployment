
# multiple S3 bucket names
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

# Create file in each S3 bucket
resource "aws_s3_object" "bucket_file" {

  for_each = local.buckets

  bucket = aws_s3_bucket.buckets[each.key].id

  key = "terraform-file.txt"

  content = <<-EOT
    Bucket Name: ${each.value}
    Bucket Type: ${each.key}
    Environment: non-prod
    Managed By: Terraform
    AWS Region: ${var.aws_region}
    Created By: Terraform
  EOT

  tags = {
    Environment = "non-prod"
    ManagedBy   = "Terraform"
  }
}