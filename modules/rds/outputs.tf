output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "db_url_ssm_arn" {
  value = aws_ssm_parameter.db_url.arn
}
