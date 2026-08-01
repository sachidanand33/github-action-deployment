resource "aws_instance" "web" {

  ami           = "ami-00d2dbb426772b03a"

  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-OIDC-EC2"
  }
}
