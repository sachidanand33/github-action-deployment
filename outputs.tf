# multiple ec2 output
output "instance_ids" {
  description = "IDs of all EC2 instances"
  value       = aws_instance.web[*].id
}

output "public_ips" {
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

# multiple s3 output
output "s3_bucket_names" {
  value = {
    for key, bucket in aws_s3_bucket.buckets :
    key => bucket.bucket
  }
}