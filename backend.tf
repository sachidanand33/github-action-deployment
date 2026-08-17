terraform {
  backend "s3" {
    bucket = "aws-terraform-state-596055752724"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}