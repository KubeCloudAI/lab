module "prod_compute_1" {
  source      = "../modules/compute"
  environment = module.prod_vpc_1.environment
  amis = {
    us-east-1 = "ami-04505e74c0741db8d" # ubuntu 20.04 LTS
    us-east-2 = "ami-04505e74c0741db90" # ubuntu 20.04 LTS
  }
  aws_region           = var.aws_region
  instance_type        = "t2.nano"
  iam_instance_profile = module.prod_iam_1.instprofile
  key_name             = "dev-mentor-keypair"
  public_subnets       = module.prod_vpc_1.public_subnets_id
  private_subnets      = module.prod_vpc_1.private_subnets_id
  sg_id                = module.prod_sg_1.sg_id
  vpc_name             = module.prod_vpc_1.vpc_name
  # natgw_id             = module.prod_natgw_1.natgw_id
  elb_listener        = module.prod_elb_1.elb_listner
  elb_listener_public = module.prod_elb_1_public.elb_listner
}
