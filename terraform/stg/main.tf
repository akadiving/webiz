terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = "default"
  region = "eu-central-1"
}
terraform {
  backend "s3" {
    bucket = "webiz-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}

resource "aws_secretsmanager_secret" "main" {
  name = "docker_credentials"
}

resource "aws_iam_role" "main" {
  name = "access_secrets_manager"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      },
    ]
  })
}

resource "aws_iam_role_policy" "main" {
  name = "access_secrets_manager"
  role = aws_iam_role.main.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "secretsmanager:GetSecretValue",
        ]
        Resource = aws_secretsmanager_secret.main.arn
        Effect   = "Allow"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "main" {
  name = "access_secrets_manager"
  role = aws_iam_role.main.name
}

resource "aws_instance" "main" {
    ami           = "ami-01e444924a2233b07" # replace with your AMI ID
    instance_type = "t2.micro" # replace with your desired instance type

    vpc_security_group_ids = [aws_security_group.main.id]

    iam_instance_profile = aws_iam_instance_profile.main.name

    tags = {
        name   = "webiz"
        env    = "stg"
    }

    user_data = file("entrypoint.sh")

    associate_public_ip_address = true
}

resource "aws_eip" "main" {
  vpc = true
}

resource "aws_eip_association" "main" {
  instance_id   = aws_instance.main.id
  allocation_id = aws_eip.main.id
}

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

module "aws" {
  source      = "../modules/aws"
  ec_instance = local.ec_instance
}