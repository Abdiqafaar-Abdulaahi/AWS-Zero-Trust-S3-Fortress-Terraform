data "aws_caller_identity" "current" {}

resource "aws_iam_role" "role" {
  name = var.role_name

  tags = {
    Project = var.project_tag
  }
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = ["sts:AssumeRole", "sts:TagSession"]
      }
    ]
  })
}

resource "aws_iam_policy" "role_policy" {
  name = "${var.role_name}-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "ListingAllBuckets"
        Effect = "Allow"
        Action = "s3:ListAllMyBuckets"
        Resource = "*"
      },
      {
        Sid = "BucketLevelPerm"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = "arn:aws:s3:::${var.project_tag}-*"
        Condition = {StringEquals = { "aws:PrincipalTag/Project" = var.project_tag}}
      },
      {
        Sid = "ObjectlevelPerms"
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = "arn:aws:s3:::${var.project_tag}-*/*"
        Condition = { StringEquals = { "aws:PrincipalTag/Project" = var.project_tag}}
      },
      {
        Sid = "KmsPerms"
        Effect = "Allow" 
        Action = ["kms:GenerateDatakey", "kms:Encrypt", "kms:Decrypt"]
        Resource = "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"
        Condition = { StringEquals = { "aws:ResourceTag/Project" = var.project_tag }}
      }
    ]
  })
}