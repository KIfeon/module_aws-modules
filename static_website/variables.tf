variable "bucket_name" {
  description = "Nom du bucket S3"
  type        = string
}

variable "index_document" {
  description = "Nom du fichier index"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Nom du fichier d'erreur"
  type        = string
  default     = "error.html"
}

variable "index_content" {
  description = "Contenu HTML du fichier index"
  type        = string
  default     = "<h1>Site statique depuis module Terraform</h1>"
}

variable "error_content" {
  description = "Contenu HTML du fichier d'erreur"
  type        = string
  default     = ""
}
