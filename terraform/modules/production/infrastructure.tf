module "prod_vpc_1" {
  source             = "../modules/network"
  vpc_cidr           = "192.168.0.0/16"
  vpc_name           = "prod-vpc-1"
  environment        = "production"
  public_cidr_block  = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
  private_cidr_block = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24"]
  azs                = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

module "prod_sg_1" {
  source        = "../modules/sg"
  vpc_name      = module.prod_vpc_1.vpc_name
  vpc_id        = module.prod_vpc_1.vpc_id
  environment   = module.prod_vpc_1.environment
  ingress_value = [22, 80, 443, 8080, 8443, 3306, 1900, 1443] # List of ports for dynamic ingress rules                                        # Example of a single port variable (not used in this module)
}

