// Data will return the VPC objects
data "aws_vpcs" "in_region" {}

data "aws_vpc" "selected" {
  for_each = toset(data.aws_vpcs.in_region.ids)
  id       = each.value
}

// Security groups
data "aws_security_groups" "all_security_groups" {}

data "aws_security_group" "all_security_group_obj" {
  for_each = toset(data.aws_security_groups.all_security_groups.ids)
  id       = each.value
}