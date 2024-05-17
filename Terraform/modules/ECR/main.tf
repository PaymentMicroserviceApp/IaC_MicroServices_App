provider "aws" {
  region = "us-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_ecr_repository" "ecr_repository" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}