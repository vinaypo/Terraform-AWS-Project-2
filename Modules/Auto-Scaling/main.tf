resource "aws_launch_template" "prod-lt" {
  name                   = var.launch_template_name
  image_id               = lookup(var.ami_id, var.region)
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.as_group_id]
  user_data              = filebase64(var.file)

  tags = {
    Name = var.launch_template_name
    Env  = var.env
  }
}

resource "aws_autoscaling_group" "prod-asg" {
  name                      = var.asgname
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns         = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.prod-lt.id
    version = "$Latest"
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_launch_template.prod-lt]
}

resource "aws_autoscaling_policy" "scale_out" {
  policy_type            = "StepScaling"
  name                   = "scale-out-policy"
  autoscaling_group_name = aws_autoscaling_group.prod-asg.name
  adjustment_type        = "ChangeInCapacity"



  step_adjustment {
    scaling_adjustment          = 1
    metric_interval_lower_bound = 0
  }
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in-policy"
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.prod-asg.name



  step_adjustment {
    scaling_adjustment          = -1
    metric_interval_upper_bound = 0
    metric_interval_lower_bound = -15
  }
  step_adjustment {
    scaling_adjustment          = -1
    metric_interval_upper_bound = -15
  }
}



resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Scale out when CPU > 80% for 5 minutes"
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.prod-asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "low-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "Scale in when CPU < 20% for 5 minutes"
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.prod-asg.name
  }

}
