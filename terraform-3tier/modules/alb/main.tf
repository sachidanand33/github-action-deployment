resource "aws_lb" "web_alb" {
  name               = "terraform-web-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.alb_sg_id
  ]

  subnets = [
    var.public_subnet_a_id,
    var.public_subnet_b_id
  ]

  enable_deletion_protection = false

  tags = {
    Name        = "Terraform-Web-ALB"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

# =========================================================
# TARGET GROUP
# =========================================================

resource "aws_lb_target_group" "web_tg" {
  name     = "terraform-web-tg"
  port     = 80
  protocol = "HTTP"

  vpc_id = var.vpc_id

  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
  }

  tags = {
    Name        = "Terraform-Web-TG"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

# =========================================================
# TARGET GROUP ATTACHMENTS
# =========================================================

resource "aws_lb_target_group_attachment" "web" {
  count = length(var.instance_ids)

  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = var.instance_ids[count.index]
  port             = 80
}

# =========================================================
# LISTENER
# =========================================================

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web_alb.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}