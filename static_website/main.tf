# Je crée un bucket S3 avec le nom qu'on donne via la variable, et j'autorise sa suppression même s'il contient des fichiers (pratique pour nettoyer facilement)
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true
}

# Je configure ce bucket pour qu'il fonctionne comme un site web statique
resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  # Indique le nom du fichier "index" du site (genre index.html)
  index_document {
    suffix = var.index_document
  }

  # Indique la page erreur
  error_document {
    key = var.error_document
  }
}

# Pour que tout le monde puisse voir le site, on met une politique publique qui autorise n'importe qui à lire les fichiers dans le bucket
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"                    # Bah tout le monde
        Action    = ["s3:GetObject"]      # Lire les fichiers
        Resource  = ["${aws_s3_bucket.this.arn}/*"]  # Dans ce bucket, tous fichiers
      }
    ]
  })
}

# Je crée le fichier index
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.this.id
  key          = var.index_document
  content      = var.index_content
  content_type = "text/html"  # C'est une page web, bien joué
}

# Page erreur perso
resource "aws_s3_object" "error" {
  count        = var.error_content == "" ? 0 : 1  # 0 = on ne crée pas, 1 = on crée
  bucket       = aws_s3_bucket.this.id
  key          = var.error_document
  content      = var.error_content
  content_type = "text/html"
}