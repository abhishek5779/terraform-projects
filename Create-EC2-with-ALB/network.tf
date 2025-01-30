#Create a VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
}

#Create a Subnet
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.subnet1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

#Create another Subnet
resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.subnet2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

#Create an Internet Gateway
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
}

#Create a Route table
resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
}

#Associate the route table with Subnet
resource "aws_route_table_association" "rt-associate1" {
  route_table_id = aws_route_table.myrt.id
  subnet_id      = aws_subnet.subnet1.id
}

#Associate the route table with Subnet 2
resource "aws_route_table_association" "rt-associate2" {
  route_table_id = aws_route_table.myrt.id
  subnet_id      = aws_subnet.subnet2.id
}