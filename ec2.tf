resource "aws_security_group" "web_sg" {
  name        = "project-webapp-web-sg"
  description = "Security group for web server via terraform"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "project-webapp-web-sg"
  }

}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
  description       = "Allow HTTP inbound traffic"

}

resource "aws_security_group_rule" "allow_https_inbound" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
  description       = "Allow HTTPS inbound traffic"

}

resource "aws_security_group_rule" "allow_all_outbound" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.web_sg.id
  description       = "Allow all outbound traffic"
}

resource "aws_security_group_rule" "allow_all_from_cloud9" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.web_sg.id
  source_security_group_id = aws_security_group.cloud9_sg.id
  description              = "Allow all inbound traffic from Cloud9 SG"
}


resource "aws_instance" "web_server_1" {
  ami                         = "ami-0360c520857e3138f" # Ubuntu Server 24.04 LTS (HVM), SSD Volume Type
  instance_type               = "t3.small"
  subnet_id                   = aws_subnet.public_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  user_data                   = file("${path.module}/scripts/UserdataScript-phase-2.sh")

  tags = {
    Name = "project-webapp-web-server-1"
  }
}

resource "aws_instance" "web_server_2" {
  ami                         = "ami-0360c520857e3138f" # Ubuntu Server 24.04 LTS (HVM), SSD Volume Type
  instance_type               = "t3.small"
  subnet_id                   = aws_subnet.public_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = "LabInstanceProfile"
  user_data                   = file("${path.module}/scripts/UserdataScript-phase-3.sh")

  tags = {
    Name = "project-webapp-web-server-2"
  }
}



# RDS SG
resource "aws_security_group" "rds_sg" {
  name        = "project-webapp-rds-sg"
  description = "Security group for RDS via terraform"
  vpc_id      = aws_vpc.main_vpc.id

  tags = {
    Name = "project-webapp-rds-sg"
  }

}

resource "aws_security_group_rule" "allow_mysql_inbound" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.web_sg.id
  description              = "Allow MySQL inbound traffic from web server SG"

}

resource "aws_security_group_rule" "allow_mysql_from_cloud9" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["10.0.1.195/32"]
  security_group_id = aws_security_group.rds_sg.id
  description       = "Allow MySQL inbound traffic from Cloud9 SG"
}

resource "aws_security_group_rule" "allow_all_outbound_rds" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds_sg.id
  description       = "Allow all outbound traffic"
}
