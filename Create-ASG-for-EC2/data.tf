#Fetch AWS EC2 instance details based on filter
data "aws_instance" "ec2-instance" {
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
  instance_tags = {
    Name = "Web1"
  }
}

data "aws_instance" "ec2-instance-1" {
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
  instance_tags = {
    Name = "Web3"
  }
}

data "aws_vpc" "my-vpc" {
    filter {
      name = "tag:Name"
      values = ["LinuxAcademy"]
    }
}