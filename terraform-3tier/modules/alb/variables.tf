variable "vpc_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "public_subnet_a_id" {
  type = string
}

variable "public_subnet_b_id" {
  type = string
}

variable "instance_ids" {
  type = list(string)
}