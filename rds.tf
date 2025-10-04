variable "db_username" {
  description = "The username for the RDS instance"
  type        = string

}

variable "db_password" {
  description = "The password for the RDS instance"
  type        = string
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "project-webapp-rds-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id,
  ]

  tags = {
    Name = "project-webapp-rds-subnet-group"
  }
}

resource "aws_db_instance" "aws_db_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t4g.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  # launch inside the VPC private subnets
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # ensure RDS is launched in the same VPC by specifying the subnet group
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    Name = "project-webapp-rds-instance"
  }

}
