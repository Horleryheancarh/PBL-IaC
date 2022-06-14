
# terraform {
#   backend "s3" {
#     bucket         = "yheancarh-dev-terraform-bucket"
#     key            = "global/s3/terraform.tfstate"
#     region         = "us-east-2"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }


terraform {
  backend "remote" {
    organization = "Yheancarh"

    workspaces {
      name = "PBL-IaC"
    }
  }
}