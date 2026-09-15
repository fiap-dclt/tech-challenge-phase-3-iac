output "sqs_queue_url" {
  value = module.sqs.queue_url
}

output "sqs_queue_arn" {
  value = module.sqs.queue_arn
}

output "secrets_arn" {
  value = module.secrets.secret_arn
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "rds_auth_endpoint" {
  value = module.rds_auth.rds_endpoint
}

output "rds_flag_endpoint" {
  value = module.rds_flag.rds_endpoint
}

output "rds_targeting_endpoint" {
  value = module.rds_targeting.rds_endpoint
}

output "redis_endpoint" {
  value = module.redis.redis_endpoint
}

output "dynamodb_table_name" {
  value = module.dynamodb.table_name
}

output "dynamodb_table_arn" {
  value = module.dynamodb.table_arn
}

output "irsa_role_arn" {
  value = module.irsa.analytics_iam_role_arn
}

output "eks_cluster_name" {
  value = try(module.eks.cluster_name, null)
}
