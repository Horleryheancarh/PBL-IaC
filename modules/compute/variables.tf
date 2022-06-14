variable "subnets_compute" {
	description = "Public subnets for compute intsance"
}

variable "ami-sonar" {
	type = string
	description = "ami for sonarqube"
}

variable "ami-jenkins" {
	type = string
	description = "ami for jenkins"
}

variable "ami-jfrog" {
	type = string
	description = "ami for jfrog"
}

variable "sg_compute" {
	description = "Secutrity group for compute instances"
}

variable "keypair" {
	type = string
	description = "keypair for instances"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}