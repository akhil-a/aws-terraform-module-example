locals {
  default_sec_groups = length(var.sec_groups) > 0 ? var.sec_groups : [data.aws_security_group.default_sg.id]

}


resource "aws_instance" "ec2_instance" {
  ami                    = var.ami_id
  key_name               = var.key_name
  vpc_security_group_ids = local.default_sec_groups
  instance_type          = var.instance_type
  subnet_id = var.subnet_id != null ? var.subnet_id : data.aws_subnets.default.ids[0]
  user_data = var.user_data != null ? var.user_data : ""
  tags = var.tags
}
