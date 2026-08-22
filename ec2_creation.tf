# ---------------------------------------------------------
# Security Group
# ---------------------------------------------------------

resource "aws_security_group" "web_sg" {
  name        = "terraform-nginx-web-sg"
  description = "Security group for Terraform Nginx EC2 instances"
  vpc_id      = aws_vpc.main.id

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    # For testing only
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Terraform-Nginx-SG"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}


# ---------------------------------------------------------
# EC2 Instances
# ---------------------------------------------------------

resource "aws_instance" "web" {
  count = 3

  ami           = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"

  # Launch all EC2 instances inside our VPC subnet
  subnet_id = aws_subnet.public.id

  # Attach security group
  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  # Automatically assign public IP
  associate_public_ip_address = true

  # Install Nginx and create file
  user_data = <<-EOF
              #!/bin/bash

              # Create Terraform file
              cat > /home/ec2-user/terraform-file.txt <<EOT
              Server Name: Terraform-OIDC-EC2-${count.index + 1}
              Environment: non-prod
              Application: Nginx
              Managed By: Terraform
              AWS Region: ${var.aws_region}
              Instance Type: t3.micro
              EOT

              # Set ownership
              chown ec2-user:ec2-user /home/ec2-user/terraform-file.txt

              # Set permissions
              chmod 600 /home/ec2-user/terraform-file.txt

              # Update packages
              dnf update -y

              # Install Nginx
              dnf install -y nginx

              # Enable Nginx
              systemctl enable nginx

              # Start Nginx
              systemctl start nginx

              # Create web page
              echo "<h1>Hello from Terraform EC2-${count.index + 1}</h1>" > /usr/share/nginx/html/index.html

              # Restart Nginx
              systemctl restart nginx
              EOF

  tags = {
    Name        = "Terraform-OIDC-EC2-${count.index + 1}"
    Environment = "non-prod"
    Application = "Nginx"
    ManagedBy   = "Terraform"
  }
}