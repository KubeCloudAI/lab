module "dev_ec2_1" {
  source      = "../modules/compute"
  environment = module.dev_vpc_1.environment
  amis = {
    us-east-1 = "ami-0ec10929233384c7f"
    us-east-2 = "ami-07062e2a343acc423"
  }
  aws_region = var.aws_region
  #   vpc_cidr        = module.dev_vpc_1.vpc_cidr
  vpc_name        = module.dev_vpc_1.vpc_name
  key_name        = "dev-mentor-keypair"
  public_subnets  = module.dev_vpc_1.public-subnet
  private_subnets = module.dev_vpc_1.private-subnet
  sg_id           = module.dev_sg_1.sg_id

}
