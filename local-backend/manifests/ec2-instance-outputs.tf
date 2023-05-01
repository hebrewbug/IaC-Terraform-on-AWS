# AWS EC2 Instance Terraform Outputs
output "ec2_bastion_public_instance_ids" {
  description = "List of IDs of instances"
  value       = module.ec2_bastion.id
}

output "ec2_bastion_public_ip" {
  description = "List of public IP addresses assigned to the instances"
  value       = module.ec2_bastion.public_ip 
}

output "ums_ec2_private_instance_ids" {
  description = "List of IDs of instances have UMS"
  value       = module.ec2_private_ums.id
}

output "ums_ec2_private_ip" {
  description = "List of private IP addresses assigned to the instances(UMS)"
  value       = module.ec2_private_ums.private_ip 
}