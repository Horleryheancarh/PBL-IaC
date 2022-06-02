# Print the exterrnal ALB to console
output "alb_dns_name" {
  value = aws_lb.ext_alb.dns_name
}

# Print the nginx target arn to console
output "alb_target_group_arn" {
  value = aws_lb_target_group.nginx_tgt.arn
}