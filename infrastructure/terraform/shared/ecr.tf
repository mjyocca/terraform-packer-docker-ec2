provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "ecr" {
  name                 = "terraform-packer-docker-project"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}