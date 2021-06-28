terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "scottbouloutian"

    workspaces {
      name = "thecraftmine"
    }
  }
}

locals {
  region           = "us-east-1"
  instances_number = 1
  environment      = "development"
  application      = "crafty"
  tags = {
    "Application" : local.application
    "Terraform" : "true"
    "Environment" : local.environment
  }
}

provider "aws" {
  region = "us-east-1"
}
