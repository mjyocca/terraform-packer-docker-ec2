terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

data "aws_ami" "image" {
  most_recent = true
  owners = ["self"]
  filter {                            
    name   = "name"
    values = ["terraform-packer-docker-*"]
  }                              
}

resource "aws_instance" "ec2" {
  count = 1
  ami                    = data.aws_ami.image.id
  instance_type          = "t2.micro"
  user_data = templatefile("./user-data.sh.tfpl", {
    region = region
    PORT_1 = 80
    PORT_2 = 8080
    id = data.aws_caller_identity.current.account_id
    repo = "terraform-packer-docker-project"
  })
}
