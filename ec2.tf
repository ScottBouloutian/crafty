data "aws_ami" "crafty" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["crafty"]
  }
}

module "security_group" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "4.2.0"
  name                = "${local.application}_security_group"
  description         = "Security group for usage with EC2 instance"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["crafty", "ssh"]
  egress_rules        = ["all-tcp"]
  rules = {
    "crafty" : [8000, 8000, "tcp", "crafty server"],
    "all-tcp" : [0, 65535, "tcp", "All TCP ports"],
    "ssh" : [22, 22, "tcp", "SSH"],
  }
}

module "ec2" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "2.19.0"
  instance_count              = local.instances_number
  name                        = "crafty-instance"
  ami                         = data.aws_ami.crafty.id
  instance_type               = "t2.medium"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = true
}

resource "aws_volume_attachment" "this" {
  count       = local.instances_number
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this[count.index].id
  instance_id = module.ec2.id[count.index]
}

resource "aws_ebs_volume" "this" {
  count             = local.instances_number
  availability_zone = module.ec2.availability_zone[count.index]
  size              = 1
}
