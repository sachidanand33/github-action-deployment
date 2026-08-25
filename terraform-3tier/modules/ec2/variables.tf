variable "aws_region" {
  type = string
}

variable "ec2_instance_count" {
  type = number
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "public_subnet_a_id" {
  type = string
}

variable "public_subnet_b_id" {
  type = string
}

variable "web_sg_id" {
  type = string
}