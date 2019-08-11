provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "minecraft" {
  ami = "ami-0ad82a384c06c911e"
  associate_public_ip_address = true
  instance_type = "a1.medium"
  key_name = "aws_scott"
  subnet_id = "subnet-044324517355fd69f"
  tags = {
    Name = "Minecraft"
  }
  vpc_security_group_ids = ["sg-0764e349ae1cc5e7a"]

  connection {
    agent = false
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("~/.ssh/aws_scott.pem")}"
  }

  provisioner "remote-exec" {
    script = "install.sh"
  }
}
