variable "ext_lb_name" {
	description = "Tag name for external alb"
}

variable "int_lb_name" {
	description = "Tag name for external alb"
}

variable "lb_type" {
	description = "Load balancer type"
}

variable "ip_address_type" {
	description = "IP address for external ALB"
}

variable "public_subnet-1" {
	description = "Public subnet for external load balancer"
}

variable "public_subnet-2" {
	description = "Public subnet for external load balancer"
}

variable "public_sg" {
	description = "External lb public secuirty group"
}

variable "private_subnet-1" {
	description = "Private subnet for internal load balancer"
}

variable "private_subnet-2" {
	description = "Private subnet for internal load balancer"
}

variable "private_sg" {
	description = "External lb public secuirty group"
}

variable "vpc_id" {
	description = "VPC id"
}

variable "domain_name" {
	description = "Domain name for the certificate or website"
}

variable "tooling_domain" {
	description = "Domain name for the certificate or website"
}

variable "wordpress_domain" {
	description = "Domain name for the certificate or website"
}

variable "tags" {
	description = "Default tags for all"
}