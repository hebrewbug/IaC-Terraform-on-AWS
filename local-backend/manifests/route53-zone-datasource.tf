# Get DNS information from AWS Route53
data "aws_route53_zone" "testdomain" {
  name         = "testdomain925.com"
}

# Output testdomain Zone ID
output "testdomain_zoneid" {
  description = "The Hosted Zone id of the desired Hosted Zone"
  value = data.aws_route53_zone.testdomain.zone_id 
}

# Output testdomain name
output "testdomain_name" {
  description = " The Hosted Zone name of the desired Hosted Zone."
  value = data.aws_route53_zone.testdomain.name
}