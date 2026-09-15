resource "aws_iam_policy" "analytics_policy" {
  name        = "irsa-policy-analytics-service-${var.env}"
  description = "Permissoes do analytics para SQS e DynamoDB"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["dynamodb:PutItem", "dynamodb:UpdateItem", "dynamodb:GetItem"]
        Resource = var.dynamodb_table_arn
      },
      {
        Effect   = "Allow"
        Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
        Resource = var.sqs_queue_arn
      }
    ]
  })
  tags = {
    Name = "irsa-policy-analytics-service-${var.env}"
  }
}

module "irsa_analytics" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "~> 6.8"

  name = "irsa-analytics-${var.env}"

  oidc_providers = {
    main = {
      provider_arn = var.eks_oidc_provider_arn
      # Formato: ["namespace:nome-da-service-account"]
      namespace_service_accounts = ["default:analytics-service-account"]
    }
  }

  policies = {
    policy = aws_iam_policy.analytics_policy.arn
  }
}

resource "aws_iam_policy" "external_secrets_policy" {
  name        = "irsa-policy-external-secrets-${var.env}"
  description = "Permissoes para o External Secrets ler senhas do RDS e descriptografar com KMS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = var.rds_secret_arns
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = var.kms_key_arn
      }
    ]
  })
  tags = {
    Name = "irsa-policy-external-secrets-${var.env}"
  }
}

module "irsa_external_secrets" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "~> 6.8"

  name = "irsa-external-secrets-${var.env}"

  oidc_providers = {
    main = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["external-secrets:external-secrets"]
    }
  }

  policies = {
    secrets = aws_iam_policy.external_secrets_policy.arn
  }
}

resource "aws_iam_role" "github_actions" {
  name = "github-actions-terragrunt-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.github_oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            # Restricts role assumption strictly to your GitHub repository
            "token.actions.githubusercontent.com:sub" = "repo:fiap-dclt/tech-challenge-phase-3-iac:*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "github_kms_decrypt" {
  name        = "github-actions-kms-decrypt-${var.env}"
  description = "Allows GitHub Actions runner to decrypt SOPS secrets using KMS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["kms:Decrypt", "kms:DescribeKey"]
        Resource = var.kms_key_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_kms_attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_kms_decrypt.arn
}
