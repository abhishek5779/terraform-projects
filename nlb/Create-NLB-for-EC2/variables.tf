variable "my-vpc" {
  type    = string
  default = "vpc-0ca211e1c3a655358"
}

variable "ami" {
    default = "ami-043a5a82b6cf98947"
    type = string
    description = "Amazon Linux 2 AMI ID"
  
}