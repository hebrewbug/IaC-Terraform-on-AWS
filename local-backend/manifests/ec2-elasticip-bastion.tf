# Create Elastic IP for Bastion Host
resource "aws_eip" "bastion_elastic_ip" {
  depends_on = [module.ec2_bastion,module.vpc] #meta-argument
  instance = module.ec2_bastion.id[0]
  vpc      = true
  tags = local.common_tags

## Local Exec Provisioner:  local-exec provisioner (Destroy-Time Provisioner - Triggered during deletion of Resource)
  provisioner "local-exec" {
    command = "echo Destroy time prov `date` >> destroy-time-prov.txt"
    working_dir = "local-exec-output-files/"
    when = destroy
    on_failure = continue
  }  
}