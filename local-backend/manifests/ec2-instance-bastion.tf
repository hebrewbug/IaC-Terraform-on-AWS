# AWS EC2 Instance Terraform Module
# Bastion Host - EC2 Instance that will be created in VPC Public Subnet
module "ec2_bastion" {
  # module needs 10 required variables
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.17.0"
  name                   = "${var.environment}-BastionHost"
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  user_data = filebase64("${path.module}/application/datadog-agent-instalation-bastion.sh")
  tags = local.common_tags
}