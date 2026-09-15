variable "env" {
  type = string
}

variable "eks_oidc_provider_arn" {
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

variable "kms_key_arn" {
  type = string
}

variable "github_oidc_provider_arn" {
  type    = string
  default = "arn:aws:kms:us-east-1:640494160208:key/f6aeb90f-f501-4286-82f9-0e2df0cd7ca8"
}
