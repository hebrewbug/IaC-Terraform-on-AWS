# Create Elastic IP for Bastion host
## Elastic Ip resourcwe will wait until IGW will be created
resource "aws_elastic_ip" "bastion_elastic_ip" {
  depends_on = [ module.ec2_bastion, module.vpc ]
  instance = module.ec2_bastion.id[0]
  vpc      = true
  tags = local.common_tags
}

#Once VPC and Bastion host are created - record it
  provisioner "local-exec" {
    command = "echo VPC created on `date` and VPC ID: ${module.vpc.vpc_id} >> creation-time-vpc-id.txt"
    working_dir = "local-exec-output-files/"
    #on_failure = continue
  }
/*
#Once VPC and Bastion were destroied by terraform destriy - record it
  provisioner "local-exec" {
    command = "echo Destroy time prov `date` >> destroy-time-prov.txt"
    working_dir = "local-exec-output-files/"
    when = destroy
    #on_failure = continue
  }  
*/