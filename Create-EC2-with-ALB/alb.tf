resource "aws_lb" "myalb" {
    load_balancer_type = "application"
    name = "myalb"
    internal = "false"
    security_groups = [aws_security_group.sg1.id]
    subnets = [aws_subnet.subnet1.id , aws_subnet.subnet2.id] 
}

resource "aws_lb_target_group" "mytg" {
    name = "mytg"
    port = "80"
    protocol = "HTTP"
    vpc_id = aws_vpc.myvpc.id
    target_type = "instance"
    
    health_check {
      path = "/"
      port = "traffic-port"
    }
}

#create a target group attachment
resource "aws_lb_target_group_attachment" "mytg-attachment-1" {
    target_group_arn = aws_lb_target_group.mytg.arn
    target_id = aws_instance.server1.id
    port = 80
}

#create a target group attachment
resource "aws_lb_target_group_attachment" "mytg-attachment-2" {
    target_group_arn = aws_lb_target_group.mytg.arn
    target_id = aws_instance.server2.id
    port = 80
}

resource "aws_lb_listener" "alblistener" {
    load_balancer_arn = aws_lb.myalb.arn
    port = "80"
    protocol = "HTTP"
    default_action {
      target_group_arn = aws_lb_target_group.mytg.arn
      type = "forward"
    }

}