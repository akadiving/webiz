locals {
  ec_instance = {
    web_server = {
      ami           = "ami-0c94855ba95c71c99"
      instance_type = "t2.micro"
      tags = {
        Name = "webiz-server"
      }
    }
  }
}