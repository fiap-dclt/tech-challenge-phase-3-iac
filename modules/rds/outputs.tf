output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "db_secret_arn" {
  value = aws_secretsmanager_secret.db_secret.arn
}

output "db_secret_name" {
  value = aws_secretsmanager_secret.db_secret.name
}

output "db_url_ssm_arn" {
  value = aws_ssm_parameter.db_url.arn
}
