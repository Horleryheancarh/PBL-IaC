# Create SNS Topic for all Auto Scaling Groups
resource "aws_sns_topic" "yheancarh_sns" {
  name = "Default_CloudWatch_Alarms_Topic"
}

# Create notification for all Auto Scaling Groups
resource "aws_autoscaling_notification" "yheancarh_notifications" {
  group_names = [
    aws_autoscaling_group.bastion_asg.name,
    aws_autoscaling_group.nginx_asg.name,
    aws_autoscaling_group.wordpress_asg.name,
    aws_autoscaling_group.tooling_asg.name
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.yheancarh_sns.arn
}

# Get list of availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Get list of AZs
resource "random_shuffle" "az_list" {
  input = data.aws_availability_zones.available.names
}

# Create Launch Template for Bastion
resource "aws_launch_template" "bastion_launch_template" {
  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = var.bastion_sg

  iam_instance_profile {
    name = var.instance_profile
  }

  key_name = var.keypair

  placement {
    availability_zone = "random_shuffle.az_list.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = "Bastion_launch_template"
      }
    )
  }

  user_data = filebase64("${path.module}/bastion.sh")
}

# Auto Scaling for Bastion
resource "aws_autoscaling_group" "bastion_asg" {
  name                      = "bastion_asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.desired_capacity

  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.bastion_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Bastion_launch_template"
    propagate_at_launch = true
  }
}

# Launch Template for Nginx
resource "aws_launch_template" "nginx_launch_template" {
  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = var.nginx_sg

  iam_instance_profile {
    name = var.instance_profile
  }

  key_name = var.keypair

  placement {
    availability_zone = "random_shuffle.az_list.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = "Nginx_launch_template"
      }
    )
  }

  user_data = filebase64("${path.module}/nginx.sh")
}

# Auto Scaling for Nginx
resource "aws_autoscaling_group" "nginx_asg" {
  name                      = "nginx_asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.desired_capacity

  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.nginx_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Nginx_launch_template"
    propagate_at_launch = true
  }
}

# Attaching Auto Scaling Group of nginx to external ALB
resource "aws_autoscaling_attachment" "asg_attachment_nginx" {
  autoscaling_group_name = aws_autoscaling_group.nginx_asg.id
  lb_target_group_arn    = var.nginx_tgt
}
