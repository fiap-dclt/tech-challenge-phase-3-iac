variable "env" {
  type = string
}

variable "queue_name" {
  type = string
}

# variable "secret_name" {
#   type = string
# }

# variable "secret_value" {
#   type      = string
#   sensitive = true
# }

variable "microservice" {
  type = string
}

variable "project" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "db_engine" {
  type = string
}

variable "db_engine_version" {
  type = string
}

variable "db_user" {
  type = string
}

variable "table_name" {
  type = string
}

variable "hash_key" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "repository_names" {
  type = list(string)
}
