region = "us-east-2"

vpc_cidr = "172.16.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

enable_classiclink_dns_support = "false"

preferred_number_of_public_subnets = 2

preferred_number_of_private_subnets = 4

name = "yheancarh"

ami-bastion = "ami-05908a69e7554ba77"

ami-nginx = "ami-0c12005be71d5ff8f"

ami-sonar = "ami-0b965a9c570392e85"

ami-web = "ami-087acc31ec7170079"

keypair = "first"

account_no = "811382253948"

master-username = "yheancarh"

master-password = "dm!n1234"

tags = {
  Environment = "dev"
  Owner       = "Yheancarh"
  Managed-by  = "Terraform"
}