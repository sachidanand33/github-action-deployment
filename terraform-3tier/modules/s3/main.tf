resource "random_id" "bucket_suffix" {
  for_each = var.buckets

  byte_length = 4
}

resource "aws_s3_bucket" "buckets" {
  for_each = var.buckets

  bucket = "${each.value}-${random_id.bucket_suffix[each.key].hex}"

  tags = {
    Name        = each.value
    Environment = "non-prod"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_object" "bucket_file" {
  for_each = var.buckets

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