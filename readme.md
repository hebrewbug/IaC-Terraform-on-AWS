
# Three-tier 

This project is a Terraform infrastructure as code (IaC) implementation for creating a scalable and highly available web application architecture on AWS. The architecture includes a VPC, public and private subnets, an application load balancer (ALB), and EC2 instances running a sample web application. It also includes an RDS MySQL database, and a bastion host (jumpbox) for secure access to the EC2 instances and RDS database. The infrastructure is created and managed using Terraform modules, and the architecture can be easily scaled by modifying the appropriate variables. Additionally, user data scripts are used to install the necessary software on the EC2 instances(apache, UMS, jumbox, datadog), making it easy to access and manage the infrastructure.

![alt text](https://github.com/hebrewbug/IaC-Terraform-on-AWS/blob/main/SOWs/VPC.png?raw=true)


## Table of Contents
- [VPC](#VPC)
- [ASG](#ASG)
- [Aplication Load Balancer (ALB)](#Aplication-Load-Balancer-(ALB))
- [Database layer - RDS](#RDS)
- [Other needed Services (Route53, ACM)](#Other-needed-Services-(Route53,-ACM))
- [Monitoring](#Monitoring)
- [Estimate Costs](#Esctimate-costs)
- [Instalation on Local Backend](#Instalation-on-Local-Backend)

## VPC 

The VPC created in this project has the following resources. Firstly, a VPC is created with the specified CIDR block(10.0.0.0/16). This VPC has two public subnets and two private subnets in different availability zones, providing high availability and fault tolerance. Additionally, two database subnets are also created in different availability zones for increased redundancy and reliability.

An Internet Gateway is attached to the VPC, allowing resources in the public subnets to communicate with the Internet. Additionally, a NAT Gateway is created for each public subnet with an Elastic IP address, providing private subnets with outbound Internet access while remaining protected from inbound traffic. The public subnets are associated with a route table that has a route to the Internet Gateway, while the private subnets are associated with a route table that has a route to the NAT Gateway. This setup ensures that resources in the private subnets can access the Internet through the NAT Gateway, while remaining secure and protected from direct Internet access. The database subnets, on the other hand, have no Internet access, ensuring that data stored in the databases remains secure and protected from external threats.

An AWS Security Group Terraform module is included in the project to define inbound rules for HTTP port 80 and SSH port 22 for entire internet access (0.0.0.0/0). Multiple EC2 instances are created in the VPC's private subnets and an EC2 instance is created in the VPC's public subnet as a bastion host. An Elastic IP is assigned to the bastion host EC2 instance.

Overall, this VPC setup provides a secure, scalable, and highly available infrastructure for running web applications, with the 3-Tier Architecture providing improved security and separation of concerns.

## ASG

This project involves the creation of launch templates and an autoscaling group using Terraform resources. The goal is to have a scalable infrastructure that can automatically adjust the number of instances in response to changes in demand.

The `asg-launch-template.tf` file defines the aws_launch_template resource that sets up a launch template for EC2 instances. The launch template specifies the image ID, instance type, VPC security group IDs, key pair, user data script, block device mappings, and monitoring settings. Additionally, the launch template is given a name prefix and a descriptive tag for easy identification.

The launch template will be used by the autoscaling group to launch new instances as needed. The autoscaling group is defined using Terraform resources and has several features enabled. First, it has autoscaling notifications that send alerts when instances are added or terminated. Second, it has autoscaling scheduled actions that can be used to adjust the capacity of the group on a specific schedule. Finally, it has autoscaling target tracking scaling policies (TTSP) that adjust the desired capacity of the group based on a target value.

The `asg-scheduled-actions.tf` file creates two scheduled actions for the Autoscaling Group, "increase_capacity_7am" and "decrease_capacity_5pm". The first scheduled action is created to increase the capacity of the Autoscaling Group to 8 instances at 7 AM UTC (which is 3 AM EST) on weekdays, and the second scheduled action is created to decrease the capacity to 2 instances at 5 PM UTC (which is 1 PM EST) on weekdays. These scheduled actions will be triggered every day at the specified time according to the "recurrence" parameter, which is set to "00 09 * * *" for the first action and "00 21 * * *" for the second action. The "autoscaling_group_name" parameter is set to the ID of the Autoscaling Group created earlier using Terraform.

The `asg-ttsp.tf` file creates two Target Tracking Scaling Policies for the Autoscaling Group. The first policy "avg_cpu_policy_greater_than_xx" is defined to scale the Autoscaling Group based on CPU utilization. This policy has a target tracking configuration with a target value of 50.0 for ASG Average CPU Utilization metric, which means that the Autoscaling Group will be scaled up or down based on the average CPU utilization of the instances in the Autoscaling Group to maintain the target value. The second policy "alb_target_requests_greater_than_yy" is defined to scale the Autoscaling Group based on the number of requests completed per target in an Application Load Balancer (ALB) target group. This policy has a target tracking configuration with a target value of 20.0 for the ALBRequestCountPerTarget metric, which means that the Autoscaling Group will be scaled up or down based on the number of requests completed per target in the specified ALB target group to maintain the target value. The "autoscaling_group_name" parameter is set to the ID of the Autoscaling Group created earlier using Terraform.

The `asg-sns.tf` file sets up the infrastructure required for sending email notifications when EC2 instances are launched or terminated within the Autoscaling Group.

This infrastructure provides a reliable and scalable solution that can handle varying levels of traffic with ease. By using launch templates and autoscaling groups, the number of instances can be increased or decreased automatically based on demand, ensuring that the application is always available and responsive.

## Aplication Load Balancer (ALB)

The `alb.tf` file is used to configure an Application Load Balancer (ALB) using Terraform. The ALB serves as a single point of contact for incoming traffic, distributing it to multiple target groups which may contain one or more instances. The ALB can be used to route traffic based on specific path patterns or protocols, and can be configured with multiple listeners, each with its own set of rules and actions.

This specific configuration file sets up an ALB with two target groups - one for an application running on port 80 and another for a database on port 8080. It also configures a HTTP listener to redirect traffic from port 80 to 443 (HTTPS) and a HTTPS listener to receive encrypted traffic on port 443. The HTTPS listener is further configured with two rules - one to forward traffic to the application target group based on path pattern and another to forward traffic to the database target group based on another path pattern. The file also includes settings for health checks, stickiness, and fixed responses, as well as tags for resource organization.

## RDS

The RDS instance will be created by `rds.tf` file with a MySQL engine version 8.0.20 and will be of type db.t3.large with allocated storage of 30GB. The instance will be created with multi-AZ redundancy, meaning it will be created in multiple availability zones to provide high availability.

The module requires the definition of variables that are used to define the database name, database username, and password - `rds.auto.tfvars`(with the seciured credentilas in `secrets.tfvars`). It also requires the definition of subnet IDs where the RDS instance will be placed and a security group ID for the instance.

The instance is created with a maintenance window and a backup window. The backup retention period is set to 0, which means no automatic backups will be taken. Performance insights are enabled with a retention period of 5 days, and a monitoring role is created for the RDS instance.

This is a Terraform configuration for launching an EC2 instance in a private subnet of a VPC. The instance is being launched using a module called "terraform-aws-modules/ec2-instance/aws".

The first step - `ec2-intance-private-ums.tf` step is the definition of the EC2 instance using the module. The module configuration includes the necessary details such as the AMI ID, instance type, keypair name, and the security group ID for the VPC. The module also takes care of launching the instance in the specified subnet(s), and assigning the necessary tags.

The second step involves running a bash script - `ums-install.tmpl` - to install Java and a web application called usermgmt-webapp.war on the EC2 instance. The script uses environment variables to configure the database connection settings, which are fetched from an RDS database instance created using a different Terraform module.

The configuration also includes the use of the "templatefile" function to pass the RDS database endpoint as a variable to the user data script that was installed on the EC2 instance. This ensures that the EC2 instance is able to connect to the RDS database instance to perform necessary operations.

The script called `jumpbox-install.sh` updates the Amazon Linux operating system, removes mariadb-libs package dependencies, enables MariaDB 10.5, and installs MariaDB and telnet on the instance. The purpose of this script is to install the MySQL client on the jumpbox instance so that it can connect to the RDS MySQL database. This is necessary because the jumpbox instance acts as a gateway to the private subnet where the RDS database is located, and it needs to have the MySQL client installed in order to establish a connection.

Overall, this Terraform configuration automates the process of launching an EC2 instance with the necessary configurations to run the usermgmt-webapp.war application, and establishes a connection to the RDS database.

## Other needed Services (Route53, ACM)

The `route53-dns.tf` file contains Terraform code for creating two Route53 DNS records using the AWS Route53 service. The aws_route53_record resource block is used to create A-type DNS records that point to the domain name specified in the dns_name variable. One DNS record named apps_dns points to the DNS name of an Application Load Balancer created in the same Terraform configuration using module.alb.lb_dns_name. Another DNS record named rds_dns points to the same DNS name of the Application Load Balancer, but with a different domain name.

On the other hand, the `route53-zone-datasource.tf` file is used to fetch the DNS zone information from AWS Route53 using the aws_route53_zone data source block. It fetches the DNS zone for the domain testdomain925.com and creates two outputs: testdomain_zoneid and testdomain_name. These outputs provide the hosted zone ID and the domain name of the Route53 DNS zone.

The `acm-certificate-manager.tf` will generate the certificat. Need to pay attention that AWS Certificate Manager can achive limit hit(up to 20 per year). To increase the limit need to open case to AWS Support.

## Monitoring

For monitoring we will use Cloudwatch and Datadog. Datadog agents will be automtcaly installed on te apache instances and will also provide appache logs collection. In addition to this Datadog agent will be installed on the Bastion instance.

The `cw-alb.tf` file defines a resource block for creating a CloudWatch alarm that monitors the number of HTTP 4xx errors generated by an Application Load Balancer (ALB) in AWS. The alarm is triggered if the number of 4xx errors exceeds a specified threshold in a given evaluation period, and sends a notification email.

This `cw-asg.tf` file defines two autoscaling policies based on CloudWatch alarms for an autoscaling group that scale-out if the CPU and memory utilization go above a certain threshold.

The first resource aws_autoscaling_policy.high_cpu defines a scaling policy named "high-cpu" that adjusts the group capacity by +4 units when triggered, with a cooldown period of 300 seconds. The same applies to the second resource aws_autoscaling_policy.high_memory, which adjusts the group capacity by +4 units when triggered based on memory utilization.

The next two resources aws_cloudwatch_metric_alarm.application_asg_cwa_cpu and aws_cloudwatch_metric_alarm.application_asg_cwa_memory define CloudWatch alarms for the CPU and memory utilization of the autoscaling group. These alarms trigger when the average CPU utilization and memory utilization are greater than or equal to the specified thresholds for 2 evaluation periods (which lasts 300 seconds each). If the alarm is triggered, it sends a notification to the specified SNS topic aws_sns_topic.myasg_sns_topic.arn and triggers the corresponding scaling policy aws_autoscaling_policy.high_cpu or aws_autoscaling_policy.high_memory.

The `cw-cis-alerts.tf` file sets up CloudWatch alarms for the CIS (Center for Internet Security) benchmark, which is a set of best practices for securing AWS resources. The file first creates a CloudWatch log group for CIS logs, and then uses the terraform-aws-modules/cloudwatch/aws//modules/cis-alarms module to define CIS alarms.

The module block specifies the source and version of the CIS alarms module, along with various inputs such as the log group name and the alarm actions (which in this case are sending notifications to an SNS topic). The disabled_controls input allows the user to disable specific CIS controls that are not applicable to their environment.

Overall, this file helps to ensure that the AWS resources are aligned with the best practices recommended by the CIS benchmark, and that any potential security issues are quickly identified and addressed through CloudWatch alarms.


## Estimate costs
 OVERALL TOTAL                                                                                                                          $356.99 
I made this report with infracost.io solution. You cam see detailed report in costs.json file.

## Instalation on Local Backend

Install Terraform CLI
Install AWS CLI


Copy repository to your Local Backup 

```terraform init```
1) Initialized Local Backend
2) Downloaded the provider plugins (initialized plugins)
3) Review the folder structure ".terraform folder"

```terraform validate```

```terraform plan```
review the resources  

```terraform apply -auto-approve```

### Clean-Up:
```terraform plan -destroy```  # You can view destroy plan using this command
or
```terraform destroy```

Delete these files
```rm -rf .terraform*```
```rm -rf terraform.tfstate```
