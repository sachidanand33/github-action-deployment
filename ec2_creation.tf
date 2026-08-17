resource "aws_instance" "web" {
  count = 4

  ami           = "ami-00d2dbb426772b03a"
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-OIDC-EC2-${count.index + 1}"
  }
}