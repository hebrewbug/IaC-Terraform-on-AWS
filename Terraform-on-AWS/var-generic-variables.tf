# Input Variables
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "eu-west-1"  
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type = string
  default = "dev"
}
# Oprganiztional Unit
variable "org_unit" {
  description = "Owners of this terraform repository within obstract Company"
  type = string
  default = "ERP"
}