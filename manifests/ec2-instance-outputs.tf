# AWS EC2 Instance Terraform Outputs
# Public EC2 Instances - Bastion Host

## ec2_bastion_public_instance_ids
output "ec2_bastion_public_instance_ids" {
  description = "List of IDs of instances"
  value       = module.ec2_bastion.id
}

## ec2_bastion_public_ip
output "ec2_bastion_public_ip" {
  description = "List of public IP addresses assigned to the instances"
  value       = module.ec2_bastion.public_ip 
}

# UMS - EC2 Instances
## ec2_private_instance_ids
output "ums_ec2_private_instance_ids" {
  description = "List of IDs of instances"
  value       = module.ec2_private_ums.id
}
## ec2_private_ip
output "ums_ec2_private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = module.ec2_private_ums.private_ip 
}