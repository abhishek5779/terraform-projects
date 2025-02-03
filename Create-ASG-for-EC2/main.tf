#Create a Launch template based on the fetched info of EC2 instance
resource "aws_launch_template" "launchtemplate" {
  name                   = "terraform-template"
  instance_type          = data.aws_instance.ec2-instance.instance_type
  image_id               = data.aws_instance.ec2-instance.ami
  vpc_security_group_ids = data.aws_instance.ec2-instance.vpc_security_group_ids
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  iam_instance_profile {
    name = data.aws_instance.ec2-instance.iam_instance_profile
  }
  disable_api_termination = true
}

#Create an Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  min_size          = 1
  max_size          = 3
  desired_capacity  = 1
  health_check_type = "EC2"
  launch_template {
    name    = aws_launch_template.launchtemplate.name
    version = aws_launch_template.launchtemplate.latest_version
  }
  //availability_zones = [data.aws_instance.ec2-instance.subnet_id]
  name                = "terraform-asg"
  vpc_zone_identifier = [data.aws_instance.ec2-instance.subnet_id, data.aws_instance.ec2-instance-1.subnet_id]
}

#Create an Auto Scaling Policy - Target Tracking Scaling
resource "aws_autoscaling_policy" "asg-policy" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  name                   = "terraform-asg-policy"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value     = 80.0
    disable_scale_in = "false"
  }
  estimated_instance_warmup = 300
}

#Create a load balancer, listener and target group and attach it to ASG
resource "aws_autoscaling_attachment" "asg-tg-attach" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = aws_lb_target_group.alb-tg.arn
}
