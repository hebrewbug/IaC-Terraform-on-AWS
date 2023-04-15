# # DNS Name Input Variable
variable "dns_name" {
  description = "DNS Name to support multiple environments"
  type = string   
}
# DNS Registrations 
resource "aws_route53_record" "apps_dns" {
  zone_id = data.aws_route53_zone.testdomain.zone_id 
  name    = var.dns_name 
  type    = "A"
  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }  
}
  resource "aws_route53_record" "rds_dns" {
  zone_id = data.aws_route53_zone.testdomain.zone_id 
  name    = "dns-to-db.testdomain925.com"
  type    = "A"
  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true  
  } 
  }
