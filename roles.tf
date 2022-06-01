# Create IAM role for EC2 to access some resources
resource "aws_iam_role" "ec2_instance_role" {
  name = "ec2_instance_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazon.com"
        }
      },
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "aws assume role"
    }
  )
}

# Create IAM policy for the EC2
resource "aws_iam_policy" "policy" {
  name        = "ec2_instance_policy"
  description = "A test policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ec2:Describe*"]
        Effect   = Allow
        Resource = "*"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "aws assume policy"
    }
  )
}

# Attach the policy to the role
resource "aws_iam_policy_attachment" "test_attach" {
  role   = aws_iam_role.ec2_instance_role.name
  policy = aws_iam_policy.policy.arn
}

# Create an Instance Profile and interpolate the IAM role
resource "aws_iam_instance" "ip" {
  name = "aws_instance_profile_test"
  role = aws_iam_role.ec2_instance_role.name
}
