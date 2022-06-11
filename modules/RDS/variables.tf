variable "db_username" {
	type = string
	description = "The Database username"
}

variable "db_password" {
	type = string
	description = "The Database password"
}

variable "db_sg" {
	description = "The Database security group"
}

variable "private_subnets" {
	type = list
	description = "Private subnets for the DB subnets group"
}

variable "tags" {
	description = "A mapping of tags to add to all resources"
	type = map(string)
	default = {}
}