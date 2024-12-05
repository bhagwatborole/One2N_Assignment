provider "aws" {
  region     = "ap-south-1"
}

resource "aws_security_group" "One2N-security" {
  name        = "One2N-security"
  description = "Allow inbound traffic to EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
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

resource "aws_iam_role" "One2N_s3readonly" {
  name = "One2N_s3readonly"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "One2N_s3readonly_policy" {
  name = "One2N_s3readonly-policy"
  role = aws_iam_role.One2N_s3readonly.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:ListBucket"
        Effect   = "Allow"
        Resource = "arn:aws:s3:::*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "One2N_s3readonly_profile" {
  name = "One2N_s3readonly-profile"
  role = aws_iam_role.One2N_s3readonly.name
}

resource "aws_instance" "web_server" {
  ami                         = "ami-022ce6f32988af5fa"
  instance_type               = "t2.micro"
  key_name                    = "one2N-ec2-key"
  security_groups             = [aws_security_group.One2N-security.name]
  iam_instance_profile        = aws_iam_instance_profile.One2N_s3readonly_profile.name
  user_data                   = file("setup_instance.sh")
  tags = {
    Name = "One2N-Web-Server2"
  }
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}

output "instance_url" {
  value = "http://${aws_instance.web_server.public_ip}:5000/list-bucket-content"
}

output "instance_test1_url" {
  value = "http://${aws_instance.web_server.public_ip}:5000/list-bucket-content/test1"
}

output "instance_test2_url" {
  value = "http://${aws_instance.web_server.public_ip}:5000/list-bucket-content/test2"
}

