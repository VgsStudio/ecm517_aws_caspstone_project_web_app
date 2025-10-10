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

# Política de Scaling: Scale UP (aumentar instâncias)
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "project-webapp-scale-up"
  scaling_adjustment     = 1 # Adiciona 1 instância por vez
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 30 # Aguarda 30 segundos antes de escalar novamente
  autoscaling_group_name = aws_autoscaling_group.web_server_2_asg.name
}

# CloudWatch Alarm: CPU > 60% → Scale UP
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "project-webapp-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2 # 2 períodos consecutivos
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 30 # 30 segundos
  statistic           = "Average"
  threshold           = 60 # 60% CPU
  alarm_description   = "Triggers scale up when CPU > 60%"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_server_2_asg.name
  }
}

# Política de Scaling: Scale DOWN (reduzir instâncias)
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "project-webapp-scale-down"
  scaling_adjustment     = -1 # Remove 1 instância por vez
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300 # Aguarda 5 minutos antes de escalar novamente
  autoscaling_group_name = aws_autoscaling_group.web_server_2_asg.name
}

# CloudWatch Alarm: CPU < 30% → Scale DOWN
resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "project-webapp-low-cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2 # 2 períodos consecutivos
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60 # 1 minuto
  statistic           = "Average"
  threshold           = 30 # 30% CPU
  alarm_description   = "Triggers scale down when CPU < 30%"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_server_2_asg.name
  }
}
