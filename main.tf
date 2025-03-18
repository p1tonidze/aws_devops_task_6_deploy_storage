# 1. Deploy an S3 storage bucket
resource "aws_s3_bucket" "grafana_backups" {
  bucket = "grafana-backups-p1tonidze"

  tags = {
    Name = "grafana_backups"
  }
}

# 2. Confugure bucket policy to allow grafana iam role to use storage
resource "aws_s3_bucket_policy" "grafana_backups_policy" {
  bucket = aws_s3_bucket.grafana_backups.id
  policy = data.aws_iam_policy_document.grafana_backup_policy.json
}

data "aws_iam_policy_document" "grafana_backup_policy" {
  statement {
    sid       = "AllowListBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.grafana_backups.arn]

    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }
  }

  statement {
    sid       = "AllowGetPutObjects"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.grafana_backups.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [var.grafana_iam_role_arn]
    }
  }
}
