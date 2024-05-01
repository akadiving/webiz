module "aws_instance" {
  source      = "./ec2/"
  ec_instance = try(var.ec_instance, {})
}
