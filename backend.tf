terraform {
  backend "s3" {
    bucket = "aws-terraform-state-851563824764"
    key    = "terraform/terraform.tfstate"
    region = "ap-south-1"
  }
}