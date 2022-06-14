variable "region" {
  type        = string
  description = "Region to deploy resources"
}

variable "vpc_cidr" {
  type        = string
  description = "The VPC CIDR"
}

variable "enable_dns_support" {
  type = bool
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "enable_classiclink" {
  type = bool
}

variable "enable_classiclink_dns_support" {
  type = bool
}

variable "preferred_number_of_public_subnets" {
  type        = number
  description = "Number of public subnets"
}

variable "preferred_number_of_private_subnets" {
  type        = number
  description = "Number of private subnets"
}

variable "name" {
  type    = string
  default = "Yheancarh"
}

variable "ami-web" {
  type        = string
  description = "AMI ID for launching web templates"
}

variable "ami-bastion" {
  type        = string
  description = "AMI ID for launching bastion templates"
}

variable "ami-nginx" {
  type        = string
  description = "AMI ID for launching nginx templates"
}

variable "ami-sonar" {
  type        = string
  description = "AMI ID for launching sonar templates"
}

variable "keypair" {
  type        = string
  description = "Keypair for the instances"
}

variable "account_no" {
  type        = string
  description = "The AWS account number"
}

variable "master-username" {
  type        = string
  description = "RDS admin username"
}

variable "master-password" {
  type        = string
  description = "RDS admin password"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}