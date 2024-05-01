provider "aws" {
  profile = "default"
  region = "eu-central-1"
}

resource "aws_secretsmanager_secret" "main" {
    for_each    = var.secrets
    name        = each.value.name
}