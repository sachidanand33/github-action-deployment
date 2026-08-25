output "alb_id" {
  value = aws_lb.web_alb.id
}

output "alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}

output "alb_url" {
  value = "http://${aws_lb.web_alb.dns_name}"
}

output "target_group_arn" {
  value = aws_lb_target_group.web_tg.arn
}