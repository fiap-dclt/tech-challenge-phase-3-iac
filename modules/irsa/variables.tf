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

variable "secrets_arns" {
  type = list(string)
}

variable "ssm_parameter_arns" {
  type = list(string)
}

variable "kms_key_arn" {
  type = string
}

variable "github_oidc_provider_arn" {
  type    = string
  default = "arn:aws:iam::640494160208:oidc-provider/token.actions.githubusercontent.com"
}
