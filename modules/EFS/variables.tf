variable "efs_subnet_1" {
	description = "Second subnet for the mount target"
}

variable "efs_subnet_2" {
	description = "First subnet for the mount target"
}

variable "efs_sg" {
	type = list
	description = "Security group for the file system"
}

variable "account_no" {
	description = "Account number of the AWS account"
}

variable "tags" {
	description = "A mapping of tags to add to all resources"
	type = map(string)
	default = {}
}