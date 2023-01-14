resource "aws_s3_bucket" "bucket" {
  bucket   = var.bucket_name
  provider = aws.sydney
}

resource "aws_s3_bucket_lifecycle_configuration" "lc" {
  bucket   = aws_s3_bucket.bucket.id
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
  bucket   = aws_s3_bucket.bucket.id
  provider = aws.sydney

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

resource "aws_iam_user" "user" {
  name = var.user_name
}

resource "aws_iam_access_key" "ak" {
  user = aws_iam_user.user.name
}

resource "aws_iam_policy" "policy" {
  name = var.policy_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [aws_s3_bucket.bucket.arn]
      },
      {
        Action = [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = [aws_s3_bucket.bucket.arn, "${aws_s3_bucket.bucket.arn}/*"]
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.policy.arn
}