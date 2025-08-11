# Get all availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch default subnet(s) in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


data "aws_security_group" "default_sg" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}
