variable "env" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "dynamodb_table_arn" {
  type = string
}

variable "sqs_queue_arn" {
  type = string
}

variable "project" {
  type = string
}

variable "rds_secret_arns" {
  type = list(string)
}
