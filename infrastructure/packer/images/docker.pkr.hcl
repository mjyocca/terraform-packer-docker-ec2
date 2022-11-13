variable "aws_account_id" {
  type = string
  default = ""
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ecr_repository" {
  type = string
  default = ""
}

packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = ">= 0.0.7"
    }
  }
}

source "docker" "node" {
  image  = "node:16"
  commit = true
  platform = "linux/amd64"
  changes = [
    "ENTRYPOINT [\"docker-entrypoint.sh\"]",
    "WORKDIR /usr/src/app",
    "CMD [ \"node\", \"server.js\" ]"
  ]
}

build {
  name = "node-docker-app"
  sources = [
    "source.docker.node"
  ]

  provisioner "file" {
    source = "../../../app/"
    destination = "/usr/src/app"
  }

  provisioner "shell" {
    inline = [
      "(cd /usr/src/app; npm ci --only=production)",
      "(cd /usr/src/app; ls)"
    ]
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_repository}"
      tags       = ["latest"]
    }
    post-processor "docker-push" {
      ecr_login      = true
      login_server   = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com"
    }
  }
}