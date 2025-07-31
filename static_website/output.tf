output "website_endpoint" {
  description = "URL du site web statique S3"
  value       = aws_s3_bucket_website_configuration.this.website_endpoint
}