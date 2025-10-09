resource "aws_launch_template" "web_server_2_launch_template" {
  name_prefix = "project-webapp-web-server-2-lt-"
  image_id    = aws_ami_from_instance.web_server_2_ami.id

  instance_type = "t3.small"

  iam_instance_profile {
    name = "LabInstanceProfile"
  }

  network_interfaces {
    security_groups = [aws_security_group.web_sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name   = "project-webapp-web-server-2"
      ORIGIN = "TERRAFORM_LAUNCH_TEMPLATE"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "web_server_2_asg" {
  desired_capacity    = 2
  max_size            = 6
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  launch_template {
    id      = aws_launch_template.web_server_2_launch_template.id
    version = "$Latest"
  }
  target_group_arns         = [aws_alb_target_group.web_server_2_tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "project-webapp-web-server-2"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

}
