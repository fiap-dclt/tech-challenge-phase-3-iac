resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.hash_key

  attribute {
    name = var.hash_key
    type = "S"
  }

  tags = {
    Name = "dynamo-${var.env}-${var.table_name}"
  }
}

resource "aws_ssm_parameter" "dynamodb_table" {
  name  = "/${var.project}/${var.env}/dynamodb/AWS_DYNAMODB_TABLE"
  type  = "String"
  value = aws_dynamodb_table.this.name
}
