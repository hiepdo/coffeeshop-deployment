# VPC Module
module "vpc" {
  source               = "../../modules/vpc"
  env                  = "dev"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Region Module
module "region" {
  source = "../../modules/region"
  region = "us-east-1a"
}


# RDS Parameter Group
resource "aws_db_parameter_group" "postgres" {
  name   = "dev-postgres-pg"
  family = "postgres16"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }

  tags = {
    Name = "dev-postgres-pg"
  }
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  vpc_id = module.vpc.vpc_id
  name   = "dev-rds-sg"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.vpc.security_group_id] # Allow traffic from EC2's security group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-rds-sg"
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "rds" {
  name       = "dev-rds-subnet-group"
  subnet_ids = module.vpc.private_subnet_ids

  tags = {
    Name = "dev-rds-subnet-group"
  }
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "postgres" {
  identifier              = "dev-postgres"
  engine                  = "postgres"
  engine_version          = "16"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  db_name                 = "coffeeshop"
  username                = "postgres"
  password                = "postgres123" # Replace with a secure password or use AWS Secrets Manager
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds.name
  parameter_group_name    = aws_db_parameter_group.postgres.name
  publicly_accessible     = false
  skip_final_snapshot     = true
  multi_az                = false

  tags = {
    Name = "dev-postgres"
  }

  depends_on = [aws_security_group.rds_sg, aws_db_subnet_group.rds, aws_db_parameter_group.postgres]
}


# EC2 Module
module "ec2" {
  source            = "../../modules/ec2"
  env               = "dev"
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.vpc.security_group_id
  instance_count    = 1
  ami               = "ami-0953476d60561c955"
  instance_type     = "t3.micro"
  depends_on        = [module.region]
}
