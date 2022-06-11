variable "subnets_compute" {
	description = "Public subnets for compute intsance"
}

variable "ami" {
	type = string
	description = "ami for jenkins jfrog and sonarqube"
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