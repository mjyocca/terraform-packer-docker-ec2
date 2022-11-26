terraform {
  cloud {
    organization = "<TFC ORGANIZATION HERE>"

    workspaces {
      name = "terraform-shared"
    }
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}