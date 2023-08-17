// Data will return the VPC objects
data "aws_vpcs" "in_region" {}

data "aws_vpc" "selected" {
  for_each = toset(data.aws_vpcs.in_region.ids)
  id       = each.value
}

// Subnets
data "aws_subnets" "all_subnets" {}

data "aws_subnet" "subnet_objs" {
  for_each = toset(data.aws_subnets.all_subnets.ids)
  id       = each.value
}