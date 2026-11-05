module "vpc" {
  source          = "../vpc"
  env             = var.env
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
  project         = var.project
}

module "sqs" {
  source     = "../sqs"
  env        = var.env
  queue_name = var.queue_name
  project    = var.project
}

module "oidc" {
  source  = "../oidc"
  env     = var.env
  project = var.project
}

module "secrets" {
  source       = "../secrets"
  env          = var.env
  secret_name  = var.secret_name
  secret_value = var.secret_value
  project      = var.project
}

module "dynamodb" {
  source     = "../dynamodb"
  env        = var.env
  table_name = var.table_name
  hash_key   = var.hash_key
  project    = var.project
}

module "eks" {
  source             = "../eks"
  env                = var.env
  kubernetes_version = var.kubernetes_version
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  project            = var.project
}

module "eso" {
  source                        = "../eso"
  external_secrets_iam_role_arn = module.irsa.external_secrets_iam_role_arn
}

module "argocd" {
  source = "../argocd"
}

module "nginx_ingress" {
  source = "../nginx"
}

module "rds_auth" {
  source                            = "../rds"
  env                               = var.env
  vpc_id                            = module.vpc.vpc_id
  private_subnet_ids                = module.vpc.private_subnet_ids
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  node_security_group_id            = module.eks.node_security_group_id
  project                           = var.project
  microservice                      = "auth-service"
  db_engine                         = var.db_engine
  db_engine_version                 = var.db_engine_version
  db_user                           = var.db_user
  db_name                           = "auth_db"
}

module "rds_flag" {
  source                            = "../rds"
  env                               = var.env
  vpc_id                            = module.vpc.vpc_id
  private_subnet_ids                = module.vpc.private_subnet_ids
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  node_security_group_id            = module.eks.node_security_group_id
  project                           = var.project
  microservice                      = "flag-service"
  db_engine                         = var.db_engine
  db_engine_version                 = var.db_engine_version
  db_user                           = var.db_user
  db_name                           = "flag_db"
}

module "rds_targeting" {
  source                            = "../rds"
  env                               = var.env
  vpc_id                            = module.vpc.vpc_id
  private_subnet_ids                = module.vpc.private_subnet_ids
  cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
  node_security_group_id            = module.eks.node_security_group_id
  project                           = var.project
  microservice                      = "targeting-service"
  db_engine                         = var.db_engine
  db_engine_version                 = var.db_engine_version
  db_user                           = var.db_user
  db_name                           = "targeting_db"
}

module "redis" {
  source                 = "../redis"
  env                    = var.env
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  node_security_group_id = module.eks.node_security_group_id
  project                = var.project
  microservice           = var.microservice
}

module "irsa" {
  source                = "../irsa"
  env                   = var.env
  eks_oidc_provider_arn = module.eks.eks_oidc_provider_arn
  dynamodb_table_arn    = module.dynamodb.table_arn
  sqs_queue_arn         = module.sqs.queue_arn
  project               = var.project
  secrets_arns = [
    module.secrets.secret_arn
  ]
  ssm_parameter_arns = [
    module.rds_auth.db_url_ssm_arn,
    module.rds_flag.db_url_ssm_arn,
    module.rds_targeting.db_url_ssm_arn,
    module.redis.redis_url_ssm_arn,
    module.sqs.sqs_url_ssm_arn,
    module.dynamodb.dynamodb_table_ssm_arn
  ]
  kms_key_arn              = var.kms_key_arn
  github_oidc_provider_arn = module.oidc.github_oidc_provider_arn
}

module "ecr" {
  source           = "../ecr"
  env              = var.env
  project          = var.project
  repository_names = toset(var.repository_names)
}
