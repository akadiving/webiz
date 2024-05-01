provider "aws" {
  profile = "default"
  region = "eu-central-1"
}

resource "aws_instance" "main" {
    for_each                    = var.ec_instance

    ami                         = each.value.ami
    tags                        = each.value.tags
    instance_type               = each.value.instance_type
    vpc_security_group_ids      = try(each.value.security_group_ids, [])
    iam_instance_profile        = try(each.value.iam_instance_profile, null)
    user_data                   = try(each.value.user_data, null)
    associate_public_ip_address = try(each.value.associate_public_ip_address, null)
}