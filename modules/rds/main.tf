resource "aws_db_subnet_group" "this" {
  name       = "subnet-group-db-${var.env}-${var.microservice}"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "subnet-group-db-${var.env}-${var.microservice}"
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "rds-${var.env}-${var.microservice}"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
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
    Name = "sg-rds-${var.env}-${var.microservice}"
  }
}

resource "random_password" "db_pass" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_secret" {
  name = "rds-${var.env}-${var.microservice}-secret"
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = random_password.db_pass.result
}

resource "aws_db_instance" "postgres" {
  identifier             = "rds-${var.env}-${var.microservice}"
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = "db.t3.small"
  allocated_storage      = 20
  username               = var.db_user
  password               = random_password.db_pass.result
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  tags = {
    Name = "rds-${var.env}-${var.microservice}"
  }
}
