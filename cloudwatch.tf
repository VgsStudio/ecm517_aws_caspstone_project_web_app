resource "aws_cloudwatch_dashboard" "webapp_dashboard" {
  dashboard_name = "project-webapp-monitoring-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", aws_autoscaling_group.web_server_2_asg.name]
          ]
          period = 60
          stat   = "Average"
          region = "us-east-1"
          title  = "Average CPU Utilization - Auto Scaling Group"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_alb.web_server_2_alb.arn_suffix]
          ]
          period = 60
          stat   = "Sum"
          region = "us-east-1"
          title  = "Total Request Count - Load Balancer"
          yAxis = {
            left = {
              min = 0
            }
          }
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HealthyHostCount", "TargetGroup", aws_alb_target_group.web_server_2_tg.arn_suffix, "LoadBalancer", aws_alb.web_server_2_alb.arn_suffix],
            [".", "UnHealthyHostCount", ".", ".", ".", "."]
          ]
          period = 60
          stat   = "Average"
          region = "us-east-1"
          title  = "Healthy vs Unhealthy Host Count - Target Group"
          yAxis = {
            left = {
              min = 0
            }
          }
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 12
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_alb.web_server_2_alb.arn_suffix]
          ]
          period = 60
          stat   = "Average"
          region = "us-east-1"
          title  = "Target Response Time - Load Balancer"
          yAxis = {
            left = {
              min = 0
            }
          }
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 12
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_2XX_Count", "LoadBalancer", aws_alb.web_server_2_alb.arn_suffix],
            [".", "HTTPCode_Target_4XX_Count", ".", "."],
            [".", "HTTPCode_Target_5XX_Count", ".", "."]
          ]
          period = 60
          stat   = "Sum"
          region = "us-east-1"
          title  = "HTTP Response Codes - Load Balancer"
          yAxis = {
            left = {
              min = 0
            }
          }
        }
      }
    ]
  })
}
