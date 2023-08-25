/*
output "enterprise_vpcs-US-West-2" {
  description = "The enterpise VPC"
  value = module.CreateEnterpriseVPCsin-US-West-2
}*/

/*output "enterprise_vpcs-US-East-2" {
  description = "The enterpise VPC"
  value = module.CreateEnterpriseVPCsin-US-East-2
}*/

output "VPC_objs" {
  description = "List all the VPC objects"
  value = module.CreateEnterpriseVPCsin-US-East-2.VPC_Info
}