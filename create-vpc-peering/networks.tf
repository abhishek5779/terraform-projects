#Create VPC in us-east-1
resource "aws_vpc" "master-vpc" {
  provider             = aws.master-region
  cidr_block           = var.master-vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Master-Vpc"
  }
}

#Create VPC in us-west-2
resource "aws_vpc" "worker-vpc" {
  provider             = aws.worker-region
  cidr_block           = var.worker-vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Worker-Vpc"
  }
}

#Create Internet Gateway in Master VPC i.e. in us-east-1
resource "aws_internet_gateway" "master-igw" {
  provider = aws.master-region
  vpc_id   = aws_vpc.master-vpc.id
  tags = {
    Name = "Master-IGW"
  }
}

#Create Internet Gateway in Worker VPC i.e. in us-west-2
resource "aws_internet_gateway" "worker-igw" {
  provider = aws.worker-region
  vpc_id   = aws_vpc.worker-vpc.id
  tags = {
    Name = "Worker-IGW"
  }
}

#Initiate VPC peering connection from Master region i.e. us-east-1
resource "aws_vpc_peering_connection" "master-to-worker" {
  provider    = aws.master-region
  vpc_id      = aws_vpc.master-vpc.id
  peer_vpc_id = aws_vpc.worker-vpc.id
  #auto_accept = true  ##Accept the peering(both VPCs need to be in the same AWS account and region).
  peer_region = var.worker-region
  tags = {
    Side = "Requester"
  }

}

#Accepts VPC peering connection at Worker region i.e. us-west-2 
resource "aws_vpc_peering_connection_accepter" "worker-accept-peering" {
  provider                  = aws.worker-region
  vpc_peering_connection_id = aws_vpc_peering_connection.master-to-worker.id
  auto_accept               = true
  tags = {
    Side = "Accepter"
  }
}

#Data block to fetch the list of AZ in us-east-1
data "aws_availability_zones" "master-az" {
  provider = aws.master-region
  state    = "available"
}

#Create Subnet in Master region i.e. us-east-1
resource "aws_subnet" "master-subnet1" {
  provider          = aws.master-region
  vpc_id            = aws_vpc.master-vpc.id
  cidr_block        = var.master-subnet1-cidr
  availability_zone = element(data.aws_availability_zones.master-az.names, 0)
  
  tags = {
    Name = "Master-Subnet1"
  }
}

#Create another Subnet in Master region i.e. us-east-1
resource "aws_subnet" "master-subnet2" {
  provider          = aws.master-region
  vpc_id            = aws_vpc.master-vpc.id
  cidr_block        = var.master-subnet2-cidr
  availability_zone = element(data.aws_availability_zones.master-az.names, 1)

  tags = {
    Name = "Master-Subnet2"
  }
}

#Create Subnet in Worker region i.e. us-west-2
resource "aws_subnet" "worker-subnet" {
  provider   = aws.worker-region
  vpc_id     = aws_vpc.worker-vpc.id
  cidr_block = var.worker-subnet-cidr

  tags = {
    Name = "Worker-Subnet"
  }
}

#Create Route table in Master region i.e. us-east-1
resource "aws_route_table" "master-rt" {
  provider = aws.master-region
  vpc_id   = aws_vpc.master-vpc.id
#   lifecycle {
#     ignore_changes = "route"
#   }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.master-igw.id
  }
  route {
    cidr_block                = var.worker-subnet-cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.master-to-worker.id
  }
  tags = {
    Name = "Master-Region-RT"
  }
}

#Overwrite default route table of VPC(Master) with our route table entries
resource "aws_main_route_table_association" "master-rt-assoc" {
  provider       = aws.master-region
  route_table_id = aws_route_table.master-rt.id
  vpc_id         = aws_vpc.master-vpc.id
}

#Create Route table in Worker region i.e. us-west-2
resource "aws_route_table" "worker-rt" {
  provider = aws.worker-region
  vpc_id   = aws_vpc.worker-vpc.id
#   lifecycle {
#     ignore_changes = "all"
#   }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.worker-igw.id
  }
  route {
    cidr_block                = var.master-subnet1-cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.master-to-worker.id
  }
  tags = {
    Name = "Worker-Region-RT"
  }
}

#Overwrite default route table of VPC(Worker) with our route table entries
resource "aws_main_route_table_association" "worker-rt-assoc" {
  provider       = aws.worker-region
  route_table_id = aws_route_table.worker-rt.id
  vpc_id         = aws_vpc.worker-vpc.id
}

#Create a security group in the master VPC to allow SSH, HTTP, and VPC peering traffic
resource "aws_security_group" "master-sg" {
  provider    = aws.master-region
  vpc_id      = aws_vpc.master-vpc.id
  name        = "jenkins-sg"
  description = "Allow TCP/8080 & TCP/22"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Allow SSH traffic from everywhere"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    description = "Allow HTTP traffic from everywhere"
  }
  ingress {
    cidr_blocks = [var.worker-subnet-cidr]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "Allow traffic from VPC peering connection"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "Allow all egress traffic"
  }
}

# Create a security group in the master VPC to allow HTTPS, HTTP, and VPC peering traffic
resource "aws_security_group" "master-sg-lb" {
  provider    = aws.master-region
  vpc_id      = aws_vpc.master-vpc.id
  name        = "lb-sg"
  description = "Allow 443 and traffic to Jenkins SG"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Allow HTTPS traffic from everywhere"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Allow HTTP traffic for redirection"
  }
  ingress {
    security_groups = [aws_security_group.master-sg.id]
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    description     = "Allow traffic to jenkins-sg"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "Allow all egress traffic"
  }
}

# Create a security group in the worker VPC to allow SSH, VPC peering traffic, and all egress traffic
resource "aws_security_group" "worker-sg" {
  name        = "worker-sg"
  provider    = aws.worker-region
  vpc_id      = aws_vpc.worker-vpc.id
  description = "Allow TCP/8080 & TCP/22"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Allow SSH traffic from everywhere"
  }
  ingress {
    cidr_blocks = [var.master-subnet1-cidr]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "Allow traffic from VPC peering connection"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "Allow all egress traffic"
  }
}