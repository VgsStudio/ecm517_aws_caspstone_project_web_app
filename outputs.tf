output "rds_endpoint" {
  description = "RDS instance endpoint (address:port)"
  value       = aws_db_instance.aws_db_instance.endpoint
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.aws_db_instance.port
}

output "rds_db_name" {
  description = "RDS database name (db_name). If you didn't set a db_name in the aws_db_instance resource this may be empty."
  value       = aws_db_instance.aws_db_instance.db_name
}

output "alb_url" {
  description = "The URL of the Application Load Balancer"
  value       = "http://${aws_alb.web_server_2_alb.dns_name}"
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_alb.web_server_2_alb.dns_name
}
