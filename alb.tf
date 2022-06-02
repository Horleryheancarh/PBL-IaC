# Create External ALB
resource "aws_lb" "ext_alb" {
  name               = "ext-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ext_alb_sg.id]
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]
  ip_address_type    = "ipv4"

  tags = merge(
    var.tags,
    {
      Name = format("%s-ext-alb", var.name)
    }
  )
}

# Nginx Target Group
resource "aws_lb_target_group" "nginx_tgt" {
  name        = "nginx-tgt"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# Nginx Listener
resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.ext_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.yheancarh_cert_val.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tgt.arn
  }
}


# Create Internal ALB
resource "aws_lb" "int_alb" {
  name               = "int-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.int_alb_sg.id]
  subnets            = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]
  ip_address_type    = "ipv4"

  tags = merge(
    var.tags,
    {
      Name = format("%s-int-alb", var.name)
    }
  )
}

# Wordpress Target Group
resource "aws_lb_target_group" "wordpress_tgt" {
  name        = "wordpress-tgt"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# Tooling Target Group
resource "aws_lb_target_group" "tooling_tgt" {
  name        = "tooling-tgt"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# Wordpress Listener
resource "aws_lb_listener" "wordpress_listener" {
  load_balancer_arn = aws_lb.int_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.yheancarh_cert_val.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tgt.arn
  }
}

# Tooling Listener rule
resource "aws_lb_listener_rule" "tooling_listener" {
  listener_arn = aws_lb_listener.wordpress_listener.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tooling_tgt.arn
  }

  condition {
    host_header {
      values = ["tooling.yinkadevops.tk"]
    }
  }
}