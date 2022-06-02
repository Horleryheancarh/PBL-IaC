# Launch Template for Wordpress
resource "aws_launch_template" "wordpress_launch_template" {
  image_id               = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver_sg]

  iam_instance_profile {
    name = aws_iam_instance_profile.ip.id
  }

  key_name = var.keypair

  placement {
    availability_zone = random_shuffle.az_list.result
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = "Wordpress_launch_template"
      }
    )
  }

  user_data = filebase64("${path.module}/wordpress.sh")
}

# Auto Scaling for Wordpress
resource "aws_autoscaling_group" "wordpress_asg" {
  name                      = "wordpress_asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1

  vpc_zone_identifier = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]

  launch_template {
    id      = aws_launch_template.wordpress_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Wordpress_launch_template"
    propagate_at_launch = true
  }
}

# Attaching Auto Scaling Group of wordpress to internal ALB
resource "aws_autoscaling_attachment" "asg_attachment_wordpress" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.id
  lb_target_group_arn    = aws_lb_target_group.wordpress_tgt.arn
}

# Launch Template for Tooling
resource "aws_launch_template" "tooling_launch_template" {
  image_id               = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver_sg]

  iam_instance_profile {
    name = aws_iam_instance_profile.ip.id
  }

  key_name = var.keypair

  placement {
    availability_zone = random_shuffle.az_list.result
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = "Tooling_launch_template"
      }
    )
  }

  user_data = filebase64("${path.module}/tooling.sh")
}

# Auto Scaling for Tooling
resource "aws_autoscaling_group" "tooling_asg" {
  name                      = "tooling_asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1

  vpc_zone_identifier = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]

  launch_template {
    id      = aws_launch_template.tooling_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Tooling_launch_template"
    propagate_at_launch = true
  }
}

# Attaching Auto Scaling Group of tooling to internal ALB
resource "aws_autoscaling_attachment" "asg_attachment_tooling" {
  autoscaling_group_name = aws_autoscaling_group.tooling_asg.id
  lb_target_group_arn    = aws_lb_target_group.tooling_tgt
}