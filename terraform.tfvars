region = "us-east-2"

vpc_cidr = "172.16.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

enable_classiclink_dns_support = "false"

preferred_number_of_public_subnets = 2

preferred_number_of_private_subnets = 4

name = "yheancarh"

ami = "ami-0b0af3577fe5e3532"

keypair = "first"

account_no = "811382253948"

master-username = "yheancarh"

master-password = "dm!n1234"

tags = {
  Environment = "dev"
  Owner       = "Yheancarh"
  Managed-by  = "Terraform"
}