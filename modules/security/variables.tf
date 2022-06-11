variable "vpc_id" {
	type = string
	description = "The VPC id"
}

variable "tags" {
	description = "A mapping of tags to add to all resources"
	type = map(string)
	default = {}
}