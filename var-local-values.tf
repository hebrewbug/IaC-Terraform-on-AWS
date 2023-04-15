# Define Local Values
locals {
  owners = var.org_unit
  environment = var.environment
  name = "${var.org_unit}-${var.environment}"
  common_tags = {
    owners = local.owners
    environment = local.environment
  }
  
  asg_tags = [
    {
      key                 = "Project"
      value               = "megasecret"
      propagate_at_launch = true
    },
    {
      key                 = "foo"
      value               = ""
      propagate_at_launch = true
    },
  ]

}