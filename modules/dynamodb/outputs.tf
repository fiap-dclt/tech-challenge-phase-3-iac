output "table_name" {
  value = aws_dynamodb_table.this.name
}

output "table_arn" {
  value = aws_dynamodb_table.this.arn
}

output "dynamodb_table_ssm_arn" {
  value = aws_ssm_parameter.dynamodb_table.arn
}
