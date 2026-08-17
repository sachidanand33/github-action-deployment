# ---------------------------------------------------------
# Security Group
# Allows SSH (22) and HTTP (80) access to all EC2 instances
# ---------------------------------------------------------

resource "aws_security_group" "web_sg" {
  name        = "terraform-nginx-web-sg"
  description = "Security group for Terraform Nginx EC2 instances"

  # SSH access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    # For testing only.
    # In production, replace this with your public IP/32.
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access for Nginx
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Terraform-Nginx-SG"
    Environment = "non-prod"
  }
}


# ---------------------------------------------------------
# EC2 Instances
# Creates 2 EC2 instances
# ---------------------------------------------------------

resource "aws_instance" "web" {
  count = 2

  ami           = "ami-00d2dbb426772b03a"
  instance_type = "t2.micro"

  # Attach the same security group to all 2 instances
  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  # Install and start Nginx automatically
  user_data = <<-EOF
              #!/bin/bash

              # Create a file on each EC2 instance
              echo "This file was created by Terraform on EC2-${count.index + 1}" > /home/ec2-user/terraform-file.txt

              # Set ownership
              chown ec2-user:ec2-user /home/ec2-user/terraform-file.txt
              
              # Update packages
              dnf update -y

              # Install Nginx
              dnf install -y nginx

              # Start Nginx automatically at boot
              systemctl enable nginx

              # Start Nginx
              systemctl start nginx

              # Create a simple web page
              echo "<h1>Hello from Terraform EC2-${count.index + 1}</h1>" > /usr/share/nginx/html/index.html

              # Restart Nginx
              systemctl restart nginx
              EOF

  tags = {
    Name        = "Terraform-OIDC-EC2-${count.index + 1}"
    Environment = "prod"
    Application = "Nginx"
  }
}