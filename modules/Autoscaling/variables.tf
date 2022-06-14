variable "max_size" {
	description = "Maximum number of instances"
}

variable "min_size" {
	description = "Minimum number of instances"
}

variable "desired_capacity" {
	description = "Desired instance capacity"
}

variable "ami-bastion" {
	description = "Ami for the bastion intances"
}

variable "ami-nginx" {
	description = "Ami for the nginx intances"
}

variable "ami-web" {
	description = "Ami for the web intances"
}

variable "keypair" {
	description = "SSH key pair"
}

variable "instance_type" {
	description = "Instance class"
}

variable "bastion_sg" {
	type = list
	description = "Security group for Bastion"
}

variable "nginx_sg" {
	type = list
	description = "Security group for Nginx"
}

variable "webserver_sg" {
	type = list
	description = "Security group for Webserver"
}

variable "private_subnets" {
	type = list
	description = "Private subnets for wordpress and tooling"
}

variable "instance_profile" {
	description = "Instance profile for launch template"
}

variable "public_subnets" {
	type = list
	description = "Public subnets for nginx"
}

variable "vpc_id" {
	description = "VPC group"
}

variable "nginx_tgt" {
	description = "Target group for nginx"
}

variable "wordpress_tgt" {
	description = "Target group for wordpress"
}

variable "tooling_tgt" {
	description = "Target group for tooling"
}

variable "tags" {
	description = "Default tags for all"
}