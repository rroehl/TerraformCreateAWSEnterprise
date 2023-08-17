// Data will return the prefix cidr  lists objects
data "aws_ec2_managed_prefix_lists" "all_managed_prefix_lists" {  }

data "aws_ec2_managed_prefix_list" "managed_prefix_list" {
  for_each = toset(data.aws_ec2_managed_prefix_lists.all_managed_prefix_lists.ids)
   id       = each.value
}

