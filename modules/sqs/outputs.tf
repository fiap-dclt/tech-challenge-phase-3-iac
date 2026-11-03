output "queue_url" {
  value = aws_sqs_queue.this.url
}

output "queue_arn" {
  value = aws_sqs_queue.this.arn
}

output "sqs_url_ssm_arn" {
  value = aws_ssm_parameter.sqs_url.arn
}
