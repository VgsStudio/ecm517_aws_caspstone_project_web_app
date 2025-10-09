resource "aws_security_group" "alb_sg" {
  name        = "project-webapp-alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main_vpc.id



}

resource "aws_security_group_rule" "alb_inbound_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id

}

resource "aws_security_group_rule" "alb_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}


resource "aws_alb" "web_server_2_alb" {
  name               = "project-webapp-web-server-2-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name = "project-webapp-web-server-2-alb"
  }

}

resource "aws_alb_target_group" "web_server_2_tg" {
  name     = "project-webapp-web-server-2-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "project-webapp-web-server-2-tg"
  }
}

resource "aws_alb_listener" "web_server_2_listener" {
  load_balancer_arn = aws_alb.web_server_2_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.web_server_2_tg.arn
  }
}
