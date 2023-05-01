# Autoscaling Group Resource
resource "aws_autoscaling_group" "application_asg" {
  name_prefix = "${local.name}-"  
  max_size = 10
  min_size = 2
  desired_capacity = 6  
  vpc_zone_identifier = module.vpc.private_subnets
  target_group_arns = module.alb.target_group_arns
  health_check_type = "EC2"
  health_check_grace_period = 300 # default is 300 seconds
  launch_template {
    id = aws_launch_template.my_launch_template.id 
    version = aws_launch_template.my_launch_template.latest_version
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      # instance_warmup = 300 # Default behavior is to use the Auto Scaling Groups health check grace period value
      min_healthy_percentage = 50            
    }
    triggers = [ "desired_capacity" ] 
  }
  tag {
    key                 = "env"
    value               = "prod"
    propagate_at_launch = true
  }
}