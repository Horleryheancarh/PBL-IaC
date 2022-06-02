# Create a key from AWS KMS
resource "aws_kms_key" "yinkadevops_kms" {
  description = "KMS key"
  policy      = <<EOF
	{
		"Version": "2012-10-17",
		"Id" : "kms-key-policy",
		"Statement" : [
			{
				"Sid": "Enable IAM User Permissions",
				"Effect": "Allow",
				"Principal": { "AWS": "arn:aws:iam::${var.account_no}:user/Olayinka" },
				"Action": "kms:*",
				"Resource": "*"
			}
		]
	}
	EOF
}

# Create key alias
resource "aws_kms_alias" "alias" {
  name          = "alias/kms"
  target_key_id = aws_kms_key.yinkadevops_kms.key_id
}

