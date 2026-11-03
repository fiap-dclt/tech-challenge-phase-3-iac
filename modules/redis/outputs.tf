output "redis_url" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "redis_port" {
  value = aws_elasticache_cluster.redis.port
}

output "redis_url_ssm_arn" {
  value = aws_ssm_parameter.redis_url.arn
}
