# Security Group Module outputs
output "SecurityGroup_Info" {
  description = "The security group objs"
  value = data.aws_security_group.all_security_group_obj
}
