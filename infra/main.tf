resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  provider = aws.sydney
  tags = {
    used_for     = "backup"
    application  = "restic"
    created_with = "terraform"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lc" {
  bucket = aws_s3_bucket.bucket.id
  provider = aws.sydney
  
  rule {
    id     = "MoveToInfrequentAccess"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }

    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
    bucket = aws_s3_bucket.bucket.id
    provider = aws.sydney
    
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
    
}
