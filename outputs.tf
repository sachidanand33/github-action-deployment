# multiple ec2 output
output "instance_ids" {
  value = aws_instance.web[*].id
}

output "public_ips" {
  value = aws_instance.web[*].public_ip
}

output "instance_names" {
  value = aws_instance.web[*].tags["Name"]
}
# multiple s3 output
output "s3_bucket_names" {
  value = {
    for key, bucket in aws_s3_bucket.buckets :
    key => bucket.bucket
  }
}