# Managde CDIR lists Module outputs
output "CIDR_Lists_Info" {
  description = "The managed CIDR lists objs"
  value = data.aws_ec2_managed_prefix_list.managed_prefix_list //data.aws_ec2_managed_prefix_lists.all_managed_prefix_lists  
}
