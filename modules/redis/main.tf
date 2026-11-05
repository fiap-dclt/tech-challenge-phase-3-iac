resource "aws_elasticache_subnet_group" "this" {
  name       = "subnet-group-redis-${var.env}-${var.microservice}"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "subnet-group-redis-${var.env}-${var.microservice}"
  }
}

resource "aws_security_group" "redis_sg" {
  name   = "redis-${var.env}-${var.microservice}"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-redis-${var.env}-${var.microservice}"
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "redis-${var.env}-${var.microservice}"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.1"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = [aws_security_group.redis_sg.id]
  tags = {
    Name = "redis-${var.env}-${var.microservice}"
  }
}

resource "aws_ssm_parameter" "redis_url" {
  name  = "/${var.microservice}/${var.env}/REDIS_URL"
  type  = "String"
  value = "redis://${aws_elasticache_cluster.redis.cache_nodes[0].address}:${aws_elasticache_cluster.redis.port}"
}
