variable "aws_region" {
  description = "The AWS region where resources will be provisioned"
  default     = "eu-central-1"
}

variable "instance_ami" {
  description = "The AMI ID for the EC2 instance"
  default     = "ami-01e444924a2233b07"
}

variable "ec_instance" {
  type = map(object({
    ami           = string
    instance_type = string
    tags          = map(string)
  }))
  description = "Information about EC2 instances"
}