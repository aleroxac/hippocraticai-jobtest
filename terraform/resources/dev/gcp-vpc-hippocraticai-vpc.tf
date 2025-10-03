module "vpc" {
  source      = "../../modules/gcp/vpc"
  vpc_name    = "hippocraticai-vpc"
  subnet_name = "hippocraticai-subnet-us-east1"
  subnet_cidr = "10.0.1.0/24"
  region      = "us-east1"
}
