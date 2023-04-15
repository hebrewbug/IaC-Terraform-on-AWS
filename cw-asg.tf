 # Define CloudWatch Alarms for Autoscaling Groups to scale-out for High CPU and Memory usage
 # Alos send the notificaiton email to users present in SNS Topic Subscription

# Autoscaling - Scaling Policy for High CPU
resource "aws_autoscaling_policy" "high_cpu" {
  name                   = "high-cpu"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.application_asg.name 
}

resource "aws_autoscaling_policy" "high_memory" {
  name                   = "high-memory"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.application_asg.name 
}

resource "aws_cloudwatch_metric_alarm" "application_asg_cwa_cpu" {
  alarm_name          = "application-ASG-CWA-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "95"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.application_asg.name 
  }

  alarm_description = "Auto-Scaling group scaling up if CPU above 95%"
  
  ok_actions          = [aws_sns_topic.myasg_sns_topic.arn]  
  alarm_actions     = [
    aws_autoscaling_policy.high_cpu.arn, 
    aws_sns_topic.myasg_sns_topic.arn
    ]
}

resource "aws_cloudwatch_metric_alarm" "application_asg_cwa_memory" {
  alarm_name          = "application-ASG-CWA-MemoryUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "90"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.application_asg.name 
  }

  alarm_description = "Scale up if Memeory above 90%"
  
  ok_actions          = [aws_sns_topic.myasg_sns_topic.arn]  
  alarm_actions     = [
    aws_autoscaling_policy.high_cpu.arn, 
    aws_sns_topic.myasg_sns_topic.arn
    ]
}