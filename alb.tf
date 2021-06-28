data "aws_acm_certificate" "issued" {
  domain   = "*.scottbouloutian.com"
  statuses = ["ISSUED"]
}

module "alb_security_group" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "4.2.0"
  name                = "${local.application}_alb_security_group"
  description         = "Security group for usage with alb"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https"]
  egress_rules        = ["all-tcp"]
  rules = {
    "https" : [443, 443, "tcp", "HTTPS"],
    "all-tcp" : [0, 65535, "tcp", "All TCP ports"],
  }
}

module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "6.2.0"
  name               = "${local.application}-alb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.alb_security_group.security_group_id]
  target_groups = [
    {
      name_prefix      = local.application
      backend_protocol = "HTTPS"
      backend_port     = 8000
      target_type      = "instance"
      targets = [
        for id in module.ec2.id :
        {
          target_id = id
          port      = 8000
        }
      ]
    }
  ]
  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.issued.arn
      target_group_index = 0
    }
  ]
  tags = local.tags
}
