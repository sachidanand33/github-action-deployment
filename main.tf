resource "aws_instance" "web" {

  ami = "ami-00d2dbb426772b03a"

  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-OIDC-EC2_04"
  }
}

# create s3 bucket
resource "aws_s3_bucket" "fist_bucket" {
  bucket = "aws-terraform-596055752724"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}