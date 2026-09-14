include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_vars = read_terragrunt_config("${get_terragrunt_dir()}/env.hcl", { locals = { env = "prod" } })

  # Extrai a variável env
  env = local.env_vars.locals.env
}

terraform {
  source = "../../modules//root"
}

inputs = {
  env             = local.env
  project         = "FIAP Tech Challenge Phase 3"
  
  # VPC
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  azs             = ["us-east-1a", "us-east-1b"]
  
  # EKS
  kubernetes_version = "1.35"
  
  # RDS
  db_engine         = "postgres"
  db_engine_version = "18.3"
  db_user           = "dbadmin"
  
  # DynamoDB
  table_name = "toggle-master-analytics-service"
  hash_key   = "id"
  
  # SQS
  queue_name = "analytics-service-queue"

  # Redis
  microservice = "evaluation-service"
  
  # Secrets Manager
  # secret_name = "db-passwords"

  # ECR
  repository_names = [
    "auth-service",
    "flag-service",
    "targeting-service",
    "evaluation-service",
    "analytics-service"
  ]
}