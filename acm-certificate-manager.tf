# ACM Module - To create and Verify SSL Certificates
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  #version = "2.14.0"
  version = "3.0.0"

  domain_name  = trimsuffix(data.aws_route53_zone.testdomain.name, ".")
  zone_id      = data.aws_route53_zone.testdomain.zone_id 

  subject_alternative_names = [
    "*.testdomain925.com",
    var.dns_name 
  ]
  tags = local.common_tags
}

# Output ACM Certificate ARN
output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = module.acm.acm_certificate_arn
}