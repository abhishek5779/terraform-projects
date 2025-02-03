#Create a internet facing Application Load Balancer
resource "aws_lb" "alb" {
  name               = "terraform-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = data.aws_instance.ec2-instance.vpc_security_group_ids
  subnets            = [data.aws_instance.ec2-instance.subnet_id, data.aws_instance.ec2-instance-1.subnet_id]
}

#Create a target group for ALB
resource "aws_lb_target_group" "alb-tg" {
  name        = "terraform-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.my-vpc.id
  health_check {
    path              = "/"
    protocol          = "HTTP"
    enabled           = true
    interval          = 30
    healthy_threshold = 4
    timeout           = 10
  }
}

#Create a listener for ALB
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}