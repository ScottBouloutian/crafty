terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "scottbouloutian"

    workspaces {
      name = "crafty"
    }
  }
}

locals {
  instances_number = 1
  environment      = "development"
  application      = "crafty"
  tags = {
    "Application" : local.application
    "Terraform" : "true"
    "Environment" : local.environment
  }
  minecraft_port = 25565
  voice_port     = 24454
}

provider "aws" {
  region     = var.aws_default_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}
