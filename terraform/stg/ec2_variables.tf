resource "aws_security_group" "main" {
  name        = "flask_sg"
  description = "Allow traffic on Flask port"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


locals {
  ec_instance = {
    webiz = {
      ami           = "ami-01e444924a2233b07"
      instance_type = "t2.micro"
      tags          = {
        name = "webiz"
        env  = "stg"
      }
      security_group_ids = [aws_security_group.main.id]
      iam_instance_profile = [aws_iam_instance_profile.main.name]
      user_data = [file("user_data.sh")]
      associate_public_ip_address = [true]
    }
  }
}