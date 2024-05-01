provider "aws" {
  profile = "default"
  region = "eu-central-1"
}

resource "aws_instance" "main" {
    for_each                    = var.ec_instance

    ami                         = each.value.ami
    tags                        = each.value.tags
    instance_type               = each.value.instance_type
    dynamic "vpc_security_group_ids" {
      for_each = try(each.value.security_group_ids, [])
      content {
        vpc_security_group_id = vpc_security_group_ids.value
      }
    }
    dynamic "iam_instance_profile" {
      for_each = try(each.value.iam_instance_profile, [])
      content {
        name = iam_instance_profile.value
      }
    }
    dynamic "user_data" {
      for_each = try(each.value.user_data, [])
      content {
        user_data = user_data.value
      }
    }
    dynamic "associate_public_ip_address" {
      for_each = try(each.value.associate_public_ip_address, [])
      content {
        associate_public_ip_address = associate_public_ip_address.value
      }
  }
}