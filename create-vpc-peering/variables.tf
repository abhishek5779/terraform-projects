variable "master-region" {
  type        = string
  description = "Master Region Name"
  default     = "us-east-1"
}

variable "worker-region" {
  default     = "us-west-2"
  type        = string
  description = "Worker Region Name"
}

variable "master-vpc-cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "VPC CIDR Block for Master region"
}

variable "worker-vpc-cidr" {
  default     = "192.168.0.0/16"
  type        = string
  description = "VPC CIDR Block for Worker region"
}

variable "master-subnet1-cidr" {
  default     = "10.0.1.0/24"
  type        = string
  description = "CIDR Block for Subnet 1 in Master region"
}

variable "master-subnet2-cidr" {
  default     = "10.0.2.0/24"
  type        = string
  description = "CIDR Block for Subnet 2 in Master region"
}

variable "worker-subnet-cidr" {
  default     = "192.168.1.0/24"
  type        = string
  description = "CIDR Block for Subnet in Worker region"
}