# Cloud9 Security Group
resource "aws_security_group" "cloud9_sg" {
  name        = "project-webapp-cloud9-sg"
  description = "Security group for Cloud9 environment"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "project-webapp-cloud9-sg"
  }
}

resource "aws_security_group_rule" "cloud9_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cloud9_sg.id
  description       = "Allow all outbound traffic"
}

resource "aws_cloud9_environment_ec2" "cloud9_env" {
  instance_type               = "t3.micro"
  name                        = "project-webapp-cloud9-env"
  image_id                    = "amazonlinux-2023-x86_64"
  subnet_id                   = aws_subnet.public_subnet_1.id
  automatic_stop_time_minutes = 30


}

resource "aws_security_group_rule" "allow_all_from_cloud9_instance" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.web_sg.id
  cidr_blocks       = ["10.0.1.195/32"]
  description       = "Allow all inbound traffic from Cloud9 subnet"
}
