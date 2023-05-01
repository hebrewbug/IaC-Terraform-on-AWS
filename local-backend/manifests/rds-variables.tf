# Terraform AWS RDS Database Variables
# Place holder file for AWS RDS Database

variable "db_name" {
  description = "AWS RDS Database Name"
  type        = string
}

variable "db_instance_identifier" {
  description = "AWS RDS Database Instance Identifier"
  type        = string
}

variable "db_username" {
  description = "AWS RDS Database Administrator Username" # DB Username - Enable Sensitive flag
  type        = string
}
variable "db_password" {
  description = "AWS RDS Database Administrator Password" # DB Password - Enable Sensitive flag
  type        = string
  sensitive   = true
}