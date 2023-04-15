# Create a Null Resource and Provisioners
resource "null_resource" "name" {
  depends_on = [module.ec2_bastion]
  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type     = "ssh"
    host     = aws_eip.bastion_elastic_ip.public_ip    
    user     = "ec2-user"
    password = ""
    private_key = file("PEM-key/prod-key.pem")
  }  

## File Provisioner: Copies the prod-key.pem file to /tmp/prod-key.pem
  provisioner "file" {
    source      = "PEM-key/prod-key.pem"
    destination = "/tmp/prod-key.pem"
  }

#Copies the datadog agent instalation script to /tmp
  provisioner "file" {
    source      = "application/datadog-agent-instalation-bastion.sh"
    destination = "/tmp/datadog-agent-instalation-bastion.sh"
  }

#Using remote-exec provisioner fix the private key permissions on Bastion Host
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/prod-key.pem"
    ]
  }

#Installing Datadog agent on the Bastion instance for monitoring
provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/datadog-agent-instalation-bastion.sh",
      "./tmp/datadog-agent-instalation-bastion.sh",
    ]
}

#Once VPC and Bastion host are created - record it
  provisioner "local-exec" {
    command = "echo VPC created on `date` and VPC ID: ${module.vpc.vpc_id} >> creation-time-vpc-id.txt"
    working_dir = "local-exec-output-files/"
    #on_failure = continue
  }

}

