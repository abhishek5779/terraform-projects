#Fetch the Public A subnet details
data "aws_subnet" "publica-subnet" {
  vpc_id = var.my-vpc
  filter {
    name   = "tag:Name"
    values = ["PublicA"]
  }
}

#Fetch the Internet Gateway details
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.my-vpc]
  }
}

#Fetch the security group details
data "aws_security_groups" "ec2-sg" {
    filter {
      name = "tag:Name"
      values = ["EC2SecurityGroup"]
    }

}

#Create a Public subnet
resource "aws_subnet" "public-subnet" {
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  vpc_id                  = var.my-vpc
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicB"
  }
}


#Create a route table
resource "aws_route_table" "RT" {
  vpc_id = var.my-vpc
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }
}

#Attach the route table to the subnet
resource "aws_route_table_association" "rt-attach" {
  route_table_id = aws_route_table.RT.id
  subnet_id      = aws_subnet.public-subnet.id
}

#Create Network ACL for subnet
resource "aws_network_acl" "public-subnet-acl" {
  vpc_id     = var.my-vpc
  subnet_ids = [aws_subnet.public-subnet.id]
  ingress {
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
    rule_no    = 100
    action     = "allow"
  }
  ingress {
    protocol   = "tcp"
    from_port  = 443
    to_port    = 443
    rule_no    = 110
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  ingress {
    protocol   = "tcp"
    to_port    = 22
    from_port  = 22
    rule_no    = 120
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
  ingress {
    protocol   = "tcp"
    from_port  = 1024
    to_port    = 65535
    rule_no    = 130
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }
   egress {
    rule_no    = 100
    action     = "allow"
    protocol   = "all"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

#Create WebA EC2 instance
resource "aws_instance" "WebA" {
    ami = var.ami
    instance_type = "t3.micro"
    subnet_id = data.aws_subnet.publica-subnet.id
    tags = {
        Name = "WebA"
    }
    associate_public_ip_address = true
    vpc_security_group_ids = data.aws_security_groups.ec2-sg.ids
    user_data = base64encode(file("WebAuser-data.sh"))
}

#Create WebB EC2 instance
resource "aws_instance" "WebB" {
    ami = var.ami
    instance_type = "t3.micro"
    subnet_id = aws_subnet.public-subnet.id
    tags = {
        Name = "WebB"
    }
    associate_public_ip_address = true
    vpc_security_group_ids = data.aws_security_groups.ec2-sg.ids
    user_data = base64encode(file("WebBuser-data.sh"))
}

#Create a Network Load Balancer
resource "aws_lb" "NLB" {
    name = "NLB4LAB"
    internal = false
    load_balancer_type = "network"
    subnets = [aws_subnet.public-subnet.id , data.aws_subnet.publica-subnet.id]
}

#Create a target group
resource "aws_lb_target_group" "nlb-tg" {
    name = "nlbTargets"
    port = 80
    protocol = "TCP"
    target_type = "instance"
    vpc_id = var.my-vpc
    health_check {
      enabled = true
      protocol = "TCP"
    }
}

#Attach the target group to the instances
resource "aws_lb_target_group_attachment" "nlb-tg-attach" {
    target_group_arn = aws_lb_target_group.nlb-tg.arn
    target_id = aws_instance.WebA.id
}

resource "aws_lb_target_group_attachment" "nlb-tg-attach-b" {
    target_group_arn = aws_lb_target_group.nlb-tg.arn
    target_id = aws_instance.WebB.id
}

#Create a listener rule
resource "aws_lb_listener" "nlb-rule" {
    load_balancer_arn = aws_lb.NLB.arn
    port = 80
    protocol = "TCP"
    default_action {
      target_group_arn = aws_lb_target_group.nlb-tg.arn
      type = "forward"
    }
}