# ---------------------------------------------------------
# Security Group
# ---------------------------------------------------------

resource "aws_security_group" "web_sg" {
  name        = "terraform-nginx-web-sg"
  description = "Security group for Terraform Nginx EC2 instances"
  vpc_id      = aws_vpc.main.id

  # SSH - temporary testing access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP - ONLY from Application Load Balancer
  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

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
  count = var.ec2_instance_count

  ami           = var.ami_id
  instance_type = var.instance_type

  # ---------------------------------------------------------
  # Launch EC2 instances in the both subnets
  # EC2-1 -> public_a -> ap-south-1a
  # EC2-2 -> public_b -> ap-south-1b
  # ---------------------------------------------------------
  subnet_id = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ][count.index]

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
              Environment: prod
              Application: Nginx
              Managed By: Terraform
              AWS Region: ${var.aws_region}
              Instance Type: ${var.instance_type}
              EOT
              
              # Set ownership
              chown ec2-user:ec2-user /home/ec2-user/terraform-file.txt

              # Set permissions
              chmod 644 /home/ec2-user/terraform-file.txt
              
              # Update packages
              dnf update -y

              # Install Nginx
              dnf install -y nginx
              
              # Enable Nginx
              systemctl enable nginx
              
              # Start Nginx
              systemctl start nginx
              
              # Create web page
              echo "<h1>Hello from Terraform nginx EC2-${count.index + 1}</h1>" > /usr/share/nginx/html/index.html
              
              # Restart Nginx
              systemctl restart nginx
              EOF

  tags = {
    Name        = "Terraform-OIDC-nginx-EC2-${count.index + 1}"
    Environment = "prod"
    Application = "Nginx"
    ManagedBy   = "Terraform"
  }
}