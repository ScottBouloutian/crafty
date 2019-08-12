resource "aws_vpc" "main" {
  cidr_block= "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "minecraft-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "thecraftmine-subnet"
  }
}

resource "aws_network_acl" "main" {
  vpc_id = "${aws_vpc.main.id}"
  subnet_ids = ["${aws_subnet.main.id}"]

  ingress {
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 22
    to_port = 22
  }

  ingress {
    protocol = "tcp"
    rule_no = 200
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 65535
  }

  egress {
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 65535
  }

  tags = {
    Name = "Minecraft VPC ACL"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    Name = "Minecraft VPC Internet Gateway"
  }
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "Minecraft VPC Route Table"
  }
}

resource "aws_route" "main" {
  route_table_id = "${aws_route_table.main.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.main.id}"
}

resource "aws_route_table_association" "main" {
    subnet_id = "${aws_subnet.main.id}"
    route_table_id = "${aws_route_table.main.id}"
}
