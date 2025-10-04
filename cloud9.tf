resource "aws_cloud9_environment_ec2" "cloud9_env" {
  instance_type               = "t3.micro"
  name                        = "project-webapp-cloud9-env"
  image_id                    = "amazonlinux-2023-x86_64"
  subnet_id                   = aws_subnet.public_subnet_1.id
  automatic_stop_time_minutes = 30

}
