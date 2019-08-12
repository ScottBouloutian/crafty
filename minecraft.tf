provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"
    values = ["Amazon Linux 2 AMI*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["Arm"]
  }

  owners = ["amazon"]
}

resource "aws_vpc" "main" {
  cidr_block= "10.0.0.0/16"
  tags = {
    Name = "minecraft-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "thecraftmine-subnet"
  }
}

resource "aws_security_group" "main" {
  name = "minecraft-group"
  description = "A minecraft security group"
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    Name = "minecraft-group"
  }

  ingress {
    from_port = 25565
    to_port = 25565
    protocol = "tcp"
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
}

resource "aws_iam_role" "main" {
  name = "minecraft-role"
  assume_role_policy = <<EOF
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
EOF
}

resource "aws_iam_instance_profile" "main" {
  name = "minecraft-profile"
  role = "${aws_iam_role.main.name}"
}

resource "aws_instance" "minecraft" {
  ami = "${data.aws_ami.amazon_linux.id}"
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.main.name}"
  instance_type = "a1.medium"
  key_name = "minecraft-key"
  subnet_id = "${aws_subnet.main.id}"
  tags = {
    Name = "Minecraft"
  }
  vpc_security_group_ids = ["${data.aws_security_group.main}"]

  connection {
    agent = false
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("~/.ssh/minecraft-key.pem")}"
  }

  provisioner "remote-exec" {
    script = "install.sh"
  }
}
