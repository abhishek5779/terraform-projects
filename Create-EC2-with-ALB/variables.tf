variable "ami" {
    description = "AMI ID for EC2 machine"
    default = "ami-0261755bbcb8c4a84"
}

variable "instance_type" {
    description = "Instance type for EC2 machine"
    default = "t2.micro"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
    description = "CIDR block for the VPC"
}

variable "subnet1_cidr" {
    default = "10.0.2.0/24"
    description = "CIDR block for the subnet1"
}

variable "subnet2_cidr" {
    default = "10.0.3.0/24"
    description = "CIDR block for the subnet1"
}