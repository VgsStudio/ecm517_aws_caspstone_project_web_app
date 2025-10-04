resource "aws_secretsmanager_secret" "db_creds" {
  name        = "Mydbsecret"
  description = "DB credentials for web app"

  tags = {
    Name = "project-webapp-db-secret"
  }
}
