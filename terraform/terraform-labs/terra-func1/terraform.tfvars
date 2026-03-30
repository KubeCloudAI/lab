aws_region = "us-east-1"
vpc_cidr = "172.18.0.0/16"
vpc_name = "my-vpc"
key_name = "dev-mentor-keypair"
azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_cidr_block = ["172.18.1.0/24", "172.18.2.0/24", "172.18.3.0/24"]
private_cidr_block = ["172.18.10.0/24", "172.18.20.0/24", "172.18.30.0/24"]
environment = "uat"
ingress_ports = [ 22, 80, 443, 3306, 5432, 6379, 27017, 9200, 9300, 11211, 27017 ]
ami_id = {
    us-east-1 = "ami-0ec10929233384c7f"
    us-east-2 = "ami-07062e2a343acc423"
}
