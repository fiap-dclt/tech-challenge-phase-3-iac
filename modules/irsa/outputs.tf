output "analytics_iam_role_arn" {
  value       = module.irsa_analytics.arn
  description = "ARN da IAM Role criada para o Service Account do analytics"
}

output "external_secrets_iam_role_arn" {
  value       = module.irsa_external_secrets.arn
  description = "ARN da IAM Role criada para o Service Account do External Secrets"
}

output "github_actions_ecr_role_arn" {
  value       = aws_iam_role.github_actions_ecr.arn
  description = "ARN da IAM Role para o GitHub Actions fazer push de imagens no ECR"
}
