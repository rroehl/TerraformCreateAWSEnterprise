# Subnet Module outputs
output "Subnet_Info" {
  description = "The Subnet config from aws"
  value = data.aws_subnet.subnet_objs
}
