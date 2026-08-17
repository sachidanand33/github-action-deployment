output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "s3_bucket_names" {
  value = {
    for key, bucket in aws_s3_bucket.buckets :
    key => bucket.bucket
  }
}