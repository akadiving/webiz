provider "aws" {
  profile = "default"
  region = "eu-central-1"
}

resource "aws_instance" "main" {
    for_each      = local.ec_instance

    ami           = each.value.ami
    tags          = each.value.tags
    instance_type = each.value.instance_type
}