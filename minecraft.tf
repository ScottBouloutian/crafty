provider "aws" {
  region = "us-east-1"
}

data "aws_ebs_volume" "main" {
  most_recent = true

  filter {
    name   = "volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "attachment.instance-id"
    values = [aws_instance.main.id]
  }
}

resource "aws_security_group" "main" {
  name = "minecraft-group"
  description = "A minecraft security group"
  vpc_id = aws_vpc.main.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 25565
    protocol = "tcp"
    to_port = 25565
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    protocol = "tcp"
    to_port = 65535
  }

  tags = {
    Name = "minecraft-group"
  }
}

resource "aws_iam_role" "main" {
  name = "minecraft-role"
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Action": ["sts:AssumeRole"],
          "Effect": "allow",
          "Principal": {
            "Service": ["ec2.amazonaws.com"]
          }
        }
    ]
}
POLICY
}

resource "aws_iam_policy" "main" {
  name = "minecraft-policy"
  description = "A minecraft policy"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": [
            "s3:PutAccountPublicAccessBlock",
            "s3:GetAccountPublicAccessBlock",
            "s3:ListAllMyBuckets",
            "s3:HeadBucket"
        ],
        "Resource": "*"
    },
    {
        "Sid": "VisualEditor1",
        "Effect": "Allow",
        "Action": "s3:*",
        "Resource": [
            "arn:aws:s3:::scottbouloutian-dev/thecraftmine*",
            "arn:aws:s3:::scottbouloutian-dev"
        ]
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "main" {
  role = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn
}

resource "aws_iam_instance_profile" "main" {
  name = "minecraft-profile"
  role = aws_iam_role.main.name
}

resource "aws_instance" "main" {
  ami = "ami-0f319c6376e4c7b75"
  iam_instance_profile = aws_iam_instance_profile.main.name
  instance_type = "t2.medium"
  key_name = "thecraftmine"
  subnet_id = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "Minecraft Server"
  }
}
