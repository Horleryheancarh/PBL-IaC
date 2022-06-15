# # Note: The bucket name may not work for you since buckets are unique globally in AWS, so you must give it a unique name.
# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "yheancarh-dev-terraform-bucket"
# }

# # Enable versioning so we can see the full revision history of our state files
# resource "aws_s3_bucket_versioning" "terraform_state" {
#   bucket = aws_s3_bucket.terraform_state.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# # Enable server-side encryption by default
# resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
#   bucket = aws_s3_bucket.terraform_state.bucket
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }


resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}


# Creating VPC
module "VPC" {
  source                              = "./modules/VPC"
  region                              = var.region
  vpc_cidr                            = var.vpc_cidr
  enable_classiclink                  = var.enable_classiclink
  enable_dns_hostnames                = var.enable_dns_hostnames
  enable_dns_support                  = var.enable_dns_support
  preferred_number_of_private_subnets = var.preferred_number_of_private_subnets
  preferred_number_of_public_subnets  = var.preferred_number_of_public_subnets
  private_subnets                     = [for i in range(1, 8, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnets                      = [for i in range(2, 5, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  tags                                = var.tags
}

# Module for Security
module "security" {
  source = "./modules/security"
  vpc_id = module.VPC.vpc_id
  tags   = var.tags
}

# Module for ALB
module "ALB" {
  source           = "./modules/ALB"
  ext_lb_name      = "Yheancarh-ext-alb"
  int_lb_name      = "Yheancarh-int-alb"
  lb_type          = "application"
  ip_address_type  = "ipv4"
  vpc_id           = module.VPC.vpc_id
  public_sg        = module.security.ALB_sg
  private_sg       = module.security.IALB_sg
  public_subnet-1  = module.VPC.public_subnets-1
  public_subnet-2  = module.VPC.public_subnets-2
  private_subnet-1 = module.VPC.private_subnets-1
  private_subnet-2 = module.VPC.private_subnets-2
  domain_name      = "*.yinkadevops.tk"
  tooling_domain   = "tooling.yinkadevops.tk"
  wordpress_domain = "wordpress.yinkadevops.tk"
  tags             = var.tags
}

# Module for Autoscaling
module "Autoscaling" {
  source           = "./modules/Autoscaling"
  vpc_id           = module.VPC.vpc_id
  ami-bastion      = var.ami-bastion
  ami-nginx        = var.ami-nginx
  ami-web          = var.ami-web
  instance_type    = "t2.micro"
  desired_capacity = 1
  min_size         = 1
  max_size         = 2
  webserver_sg     = [module.security.web_sg]
  bastion_sg       = [module.security.bastion_sg]
  nginx_sg         = [module.security.nginx_sg]
  private_subnets  = [module.VPC.private_subnets-1, module.VPC.private_subnets-2]
  public_subnets   = [module.VPC.public_subnets-1, module.VPC.public_subnets-2]
  nginx_tgt        = module.ALB.nginx_tgt
  tooling_tgt      = module.ALB.tooling_tgt
  wordpress_tgt    = module.ALB.wordpress_tgt
  keypair          = var.keypair
  instance_profile = module.VPC.instance_profile
  tags             = var.tags
}

# Module for EFS
module "EFS" {
  source       = "./modules/EFS"
  efs_subnet_1 = module.VPC.private_subnets-1
  efs_subnet_2 = module.VPC.private_subnets-2
  efs_sg       = [module.security.datalayer_sg]
  account_no   = var.account_no
  tags         = var.tags
}

# Module for RDS
module "RDS" {
  source          = "./modules/RDS"
  db_username     = var.master-username
  db_password     = var.master-password
  db_sg           = module.security.datalayer_sg
  private_subnets = [module.VPC.private_subnets-3, module.VPC.private_subnets-4]
  tags            = var.tags
}

# Module for compute
module "compute" {
  source          = "./modules/compute"
  ami-sonar       = var.ami-sonar
  ami-jenkins     = var.ami-bastion
  ami-jfrog       = var.ami-bastion
  subnets_compute = module.VPC.public_subnets-1
  sg_compute      = [module.security.ALB_sg]
  keypair         = var.keypair
  tags            = var.tags
}