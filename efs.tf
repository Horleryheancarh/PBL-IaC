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

# Create EFS
resource "aws_efs_file_system" "yinkadevops_efs" {
  encrypted  = true
  kms_key_id = aws_kms_key.yinkadevops_kms.arn

  tags = merge(
    var.tags,
    {
      Name = "yinkadevops-efs"
    }
  )
}

# Create mount targets for EFS
resource "aws_efs_mount_target" "subnet_1" {
  file_system_id  = aws_efs_file_system.yinkadevops_efs.id
  subnet_id       = aws_subnet.private_subnet[2].id
  security_groups = [aws_security_group.datalayer_sg.id]
}

resource "aws_efs_mount_target" "subnet_2" {
  file_system_id  = aws_efs_file_system.yinkadevops_efs.id
  subnet_id       = aws_subnet.private_subnet[3].id
  security_groups = [aws_security_group.datalayer_sg.id]
}

# Create access point for wordpress
resource "aws_efs_access_point" "wordpress_ap" {
  file_system_id = aws_efs_file_system.yinkadevops_efs.id

  posix_user {
    gid = 0
    uid = 0
  }

  root_directory {
    path = "/wordpress"

    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = 0755
    }
  }
}

# Create access point for tooling
resource "aws_efs_access_point" "tooling_ap" {
  file_system_id = aws_efs_file_system.yinkadevops_efs.id

  posix_user {
    gid = 0
    uid = 0
  }

  root_directory {
    path = "/tooling"

    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = 0755
    }
  }
}
