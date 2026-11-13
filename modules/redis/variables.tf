variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "cluster_primary_security_group_id" {
  type = string
}

# variable "node_security_group_id" {
#   type = string
# }

variable "microservice" {
  type = string
}

variable "project" {
  type = string
}
