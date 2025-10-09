resource "aws_ami_from_instance" "web_server_2_ami" {
  name                    = "project-webapp-web-server-2-ami"
  source_instance_id      = aws_instance.web_server_2.id
  snapshot_without_reboot = false
  description             = "AMI created from web_server_2"

  tags = {
    Name = "project-webapp-web-server-2-ami"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name, source_instance_id] # Ignore changes after first creation
  }
}

output "web_server_2_ami_id" {
  value = aws_ami_from_instance.web_server_2_ami.id
}

resource "aws_ec2_instance_state" "web_server_2_stop" {
  instance_id = aws_instance.web_server_2.id
  state       = "stopped"

  # This ensures the instance is stopped only after AMI is created
  depends_on = [aws_ami_from_instance.web_server_2_ami]
}
