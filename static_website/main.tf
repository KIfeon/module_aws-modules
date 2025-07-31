resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["${aws_s3_bucket.this.arn}/*"]
      }
    ]
  })
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.this.id
  key          = var.index_document
  content      = var.index_content
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  count        = var.error_content == "" ? 0 : 1
  bucket       = aws_s3_bucket.this.id
  key          = var.error_document
  content      = var.error_content
  content_type = "text/html"
}