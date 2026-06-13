data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "bucket" {
    bucket = var.bucket_name

    tags = {
        Project = var.authorized_project
    }
}

resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.bucket.id 
    versioning_configuration  {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_public_access_block" "pab" {
    bucket = aws_s3_bucket.bucket.id 

    block_public_acls = true 
    block_public_policy = true 
    ignore_public_acls = true 
    restrict_public_buckets = true
}

resource "aws_kms_key" "kms" {
    deletion_window_in_days = 7 
    enable_key_rotation = true
    description = "kms key for ${var.bucket_name}"

    tags = {
        Project = var.authorized_project
    }

    policy  = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid = "AllowAdmins"
                Effect = "Allow"
                Principal = {
                    AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
                }
                Action = "kms:*"
                Resource = "*"
            }
        ]
    })
}


resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
    bucket = aws_s3_bucket.bucket.id
    
    
    rule {
        bucket_key_enabled = true
        apply_server_side_encryption_by_default {
            kms_master_key_id = aws_kms_key.kms.arn 
            sse_algorithm = "aws:kms"
        }
    }
}

resource "aws_s3_bucket_policy" "s3_policy" {
    bucket = aws_s3_bucket.bucket.id 

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid = "HttpsAccessOnly"
                Effect = "Deny"
                Principal = "*"
                Action = "s3:*"
                Resource = [aws_s3_bucket.bucket.arn, "${aws_s3_bucket.bucket.arn}/*"]
                Condition = { Bool = { "aws:SecureTransport" = false } }
            },
            {
                Sid = "KmsEncryptedUploadOnly"
                Effect = "Deny"
                Principal = "*"
                Action = "s3:PutObject"
                Resource = [aws_s3_bucket.bucket.arn, "${aws_s3_bucket.bucket.arn}/*"]
                Condition = { StringNotEquals = { "s3:x-amz-server-side-encryption" = "aws:kms"}}
            },
            {
                Sid = "AuthorizedAccessOnly"
                Effect = "Deny"
                Principal = "*"
                Action = "s3:*"
                Resource = [aws_s3_bucket.bucket.arn, "${aws_s3_bucket.bucket.arn}/*"]
                Condition = {
                     ArnNotLike = { "aws:PrincipalArn" = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root", "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/test-user"]}
                     StringNotEquals = { "aws:PrincipalTag/Project" = var.authorized_project}
                     }
            }
        ]
    }) 
}


