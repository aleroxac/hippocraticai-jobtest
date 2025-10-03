variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "subnet_cidr" {
  description = "Subnet CIDR (ex: 10.0.1.0/24)"
  type        = string
}

variable "region" {
  description = "Region to create the subnet"
  type        = string
}
