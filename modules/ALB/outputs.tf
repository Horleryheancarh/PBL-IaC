# Print the exterrnal ALB to console
output "alb_dns_name" {
  value = aws_lb.ext_alb.dns_name
  description = "External load balance arn"
}

# Print the nginx target arn to console
output "nginx_tgt" {
  value = aws_lb_target_group.nginx_tgt.arn
  description = "External load balancer target group"
}

# Print the wordpress target arn to console
output "wordpress_tgt" {
  value = aws_lb_target_group.wordpress_tgt.arn
  description = "External load balancer wordpress group"
}

# Print the tooling target arn to console
output "tooling_tgt" {
  value = aws_lb_target_group.tooling_tgt.arn
  description = "External load balancer tooling group"
}