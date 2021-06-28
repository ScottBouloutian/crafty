module "records" {
  source    = "terraform-aws-modules/route53/aws//modules/records"
  version   = "2.1.0"
  zone_name = "scottbouloutian.com"
  records = [
    {
      name = local.application
      type = "A"
      alias = {
        name    = module.alb.lb_dns_name
        zone_id = module.alb.lb_zone_id
      }
    },
  ]
}
