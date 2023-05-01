###### Target Tracking Scaling Policies ######
# TTS - Scaling Policy-1: Based on CPU Utilization
# Defining Autoscaling Policies and Associate them to particular ASG
resource "aws_autoscaling_policy" "avg_cpu_policy_greater_than_xx" {
  name = "${local.name}-avg-cpu-policy-greater-than-xx"
  policy_type = "TargetTrackingScaling"    
  autoscaling_group_name = aws_autoscaling_group.application_asg.id 
  estimated_instance_warmup = 180  # defaults is 300 seconds if not set 
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0 # CPU Utilization is above 70%
  }  
 
}

# TTS - Scaling Policy-2: Based on ALB Target Requests
resource "aws_autoscaling_policy" "alb_target_requests_greater_than_yy" {
  name = "${local.name}-alb-target-requests-greater-than-yy"
  policy_type = "TargetTrackingScaling" # Important Note: The policy type, either "SimpleScaling", "StepScaling" or "TargetTrackingScaling". If this value isn't provided, AWS will default to "SimpleScaling."    
  autoscaling_group_name = aws_autoscaling_group.application_asg.id 
  estimated_instance_warmup = 120 
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label =  "${module.alb.lb_arn_suffix}/${module.alb.target_group_arn_suffixes[0]}"    
    }  
    target_value = 20.0 # Number of requests > 20 completed per target in an Application Load Balancer target group.
  }    
}