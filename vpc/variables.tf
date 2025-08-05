
variable "vpc_cidr_block" {
  description = "cidr block of VPC"
  type        = string
}

variable "enable_nat_gw" {

  description = "Set true to enable nat gw"
  type        = bool
  default = false
}


variable "public_subnet_count" {
  description = "number of public subnets"
  type = number
}

variable "private_subnet_count" {
  description = "number of public subnets"
  type = number
  default = 0
}


variable "enable_private_subnet" {

  description = "Set true to enable private subnets"
  type        = bool
  default = false
}

variable "project_name" {
  description = "project name"
  type        = string
}

variable "project_env" {
  description = "project environment"
  type        = string
}


variable "subnet_newbits" {
  description = "Number of additional bits to extend the subnet mask"
  type = number
}

variable "az_count" {
  type        = number
  default     = 2
  description = "Number of Availability Zones to use for subnet placement"
}