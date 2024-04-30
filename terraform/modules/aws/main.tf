terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.2.0"
}

terraform {
  backend "s3" {
    bucket = "webiz-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}

module "aws_instance" {
  source      = "./ec2/"
  ec_instance = try(var.ec_instance, {})
}
