resource "aws_secretsmanager_secret" "this" {
  name                    = "${var.env}-${var.secret_name}-secret"
  recovery_window_in_days = 0
  tags = {
    Name = "${var.env}-${var.secret_name}-secret"
  }
}

resource "aws_secretsmanager_secret_version" "this_version" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.secret_value
}
