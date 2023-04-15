# AWS EC2 Security Group Terraform Module
# Security Group for Private EC2 Instances
module "private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.5.0"
  
  #name = "private-sg"
  name = "${local.name}-private-sg"  
  description = "Security Group with HTTP & SSH port open for entire VPC Block (IPv4 CIDR), egress ports are all internet faced"
  vpc_id = module.vpc.vpc_id
  # Ingress Rules & CIDR Blocks, TCP included
  ingress_rules = ["ssh-tcp", "http-80-tcp", "http-8080-tcp"]
  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags = local.common_tags
}
