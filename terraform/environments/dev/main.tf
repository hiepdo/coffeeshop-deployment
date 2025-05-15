module "vpc" {
  source               = "../../modules/vpc"
  env                  = "dev"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}

module "region" {
  source = "../../modules/region"
  region = "us-east-1a"
}

module "ec2" {
  source            = "../../modules/ec2"
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.vpc.security_group_id
  count             = 1
  ami               = "ami-0953476d60561c955"
  instance_type     = "t3.micro"
  depends_on        = [module.region]
}   