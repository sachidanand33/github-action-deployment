resource "aws_instance" "web" {
  count = var.ec2_instance_count

  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = [
    var.public_subnet_a_id,
    var.public_subnet_b_id
  ][count.index % 2]

  vpc_security_group_ids = [
    var.web_sg_id
  ]

  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash

    cat > /home/ec2-user/terraform-file.txt <<EOT
    Server Name: Terraform-OIDC-EC2-${count.index + 1}
    Environment: prod
    Application: Nginx
    Managed By: Terraform
    AWS Region: ${var.aws_region}
    Instance Type: ${var.instance_type}
    EOT

    chown ec2-user:ec2-user /home/ec2-user/terraform-file.txt
    chmod 644 /home/ec2-user/terraform-file.txt

    dnf update -y
    dnf install -y nginx

    systemctl enable nginx
    systemctl start nginx

    echo "<h1>Hello from Terraform nginx EC2-${count.index + 1}</h1>" > /usr/share/nginx/html/index.html

    systemctl restart nginx
  EOF

  tags = {
    Name        = "Terraform-OIDC-nginx-EC2-${count.index + 1}"
    Environment = "prod"
    Application = "Nginx"
    ManagedBy   = "Terraform"
  }
}