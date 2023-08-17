# Subnet Module outputs
output "NetworkAcl_Info" {
  description = "The Network Acl config from aws"
  value = data.aws_network_acls.all_networkacls
}
