output "instance_ids" {
  value = aws_instance.web[*].id
}

output "private_ips" {
  value = aws_instance.web[*].private_ip
}

output "public_ips" {
  value = aws_instance.web[*].public_ip
}

output "availability_zones" {
  value = aws_instance.web[*].availability_zone
}

output "subnet_ids" {
  value = aws_instance.web[*].subnet_id
}

output "instance_names" {
  value = aws_instance.web[*].tags["Name"]
}