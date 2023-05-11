terraform {
  cloud {
      organization = "SennaTutorial"
      workspaces {
        name = "learn-tfc-aws"
      }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "app_server" {
  ami           = "*ami-name*"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["*id*"]
  subnet_id              = "subnet-*id*"

  tags = {
    Name = var.instance_name
  }
}
