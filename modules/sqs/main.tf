resource "aws_sqs_queue" "this" {
  name = "sqs-${var.env}-${var.queue_name}"

  tags = {
    Name = "sqs-${var.env}-${var.queue_name}"
  }
}

resource "aws_ssm_parameter" "sqs_url" {
  name  = "/${var.project}/${var.env}/sqs/AWS_SQS_URL"
  type  = "String"
  value = aws_sqs_queue.this.url
}
