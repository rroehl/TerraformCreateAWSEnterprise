# VPC Module outputs
output "VPC_Info" {
  description = "The VPCs objs----------------------------------->"
  value = data.aws_vpc.selected
}
