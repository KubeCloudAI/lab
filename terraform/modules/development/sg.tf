module "dev_sg_1" {
  source        = "../modules/sg"
  vpc_name      = module.dev_vpc_1.vpc_name
  vpc_id        = module.dev_vpc_1.vpc_id
  environment   = module.dev_vpc_1.environment
  ingress_value = [22, 80, 443, 8080, 8443, 3306, 1900, 1443] # List of ports for dynamic ingress rules                                        # Example of a single port variable (not used in this module)
}
