
variable "instance_type" {
  description = "t2 micro usually"
  type        = string
}

variable "ami_id" {
  description = "ami id"
  type        = string
}

variable "project_name" {
  description = "project name"
  type        = string
}

variable "project_env" {
  description = "project environment"
  type        = string
}

variable "user_data" {
  description = "User data script for EC2 instance"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "key name for EC2 instance"
  type        = string
  default     = ""
}

variable "sec_groups"{
  description = "list of security groups to attach to EC2 instances"
  type=list(string)
  default = []
}

variable "subnet_id" {
  description = "key name for EC2 instance"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to the EC2 instance"
  type        = map(string)
  default     = {}
}
