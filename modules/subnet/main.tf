terraform {
  required_version = ">= 1.3.7" 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
      configuration_aliases = [ aws ]
    }
  }
}

variable "vpc_region" {
  type = string
  description = "AWS Region"
  validation {
	condition = ( var.vpc_region == "us-east-2" || var.vpc_region == "us-west-2" || var.vpc_region == "us-west-1" || var.vpc_region == "us-east-1")
	error_message = "Region can be us-east-2 or us-west-2."
    }
} 

// Get the enterprise data structure from common module
module "enterprise_config_module" {
    source = "../common"
    //module.enterprise_config.enterprise_config 
}

# Create Subnets
resource "aws_subnet" "create_subnets" {
//depends_on = [aws_vpc_ipv4_cidr_block_association.secondary_cidr]   //local.vpc_depends_on] 

  for_each = {
    for subnet in local.vpc_network_subnets :  "${subnet.vpc_name}.${subnet.az_name}.${subnet.cidr_block}" => subnet if subnet.vpc_region_name == var.vpc_region
    }
  //vpc_id = lookup(aws_vpc.this, "${each.value.vpc_name}").id 
  vpc_id = [for key, obj in values(data.aws_vpc.selected).*: obj.id  if obj.tags.uuid== "${each.value.vpc_uuid}"][0] 

  cidr_block =  each.value.cidr_block
  availability_zone = each.value.az_name
  map_public_ip_on_launch = false

  tags = {
      Name = join( " ", ["${each.key}"])
      CIDR_block = each.value.cidr_block
      "Environment_Type" =  each.value.vpc_environment_type
      "Subnet Class_Type"  = each.value.sn_class_type
      "uuid"  = each.value.sn_uuid
      "Availability_Zone" = each.value.az_name
      "VPC" = each.value.vpc_name
      "Date_created" = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
  } 
}

# Get the Subnets info from map
locals {
  // outer map key: vpc Name
  // inner map key: vpc object
  // outer map key: AZ Name
  // inner map key: Az map
  // outer map value: subnet CIDR
  // inner map key: subnet object

  vpc_network_subnets =  flatten([
    for region_key, region_obj in module.enterprise_config_module.enterprise_config : [  
      for vpc_key, vpc_obj in region_obj.vpc_info : [
        for az_key, az_subnet_objs in vpc_obj.az_info : [
          for subnet_key, subnet_obj in az_subnet_objs : {
            vpc_region_name = region_key
            vpc_name = vpc_key
            vpc_uuid = vpc_obj.vpc_uuid
            az_name = az_key
            vpc_cidr_block = vpc_obj.vpc_cidr_block 
            vpc_enable_dns_support = vpc_obj.vpc_enable_dns_support
            vpc_enable_dns_hostnames = vpc_obj.vpc_enable_dns_hostnames
            vpc_environment_type = vpc_obj.vpc_environment_type
            cidr_block = subnet_key
            sn_class_type = subnet_obj.sn_class_type
            sn_uuid = subnet_obj.sn_uuid
            } 
        ]
      ]
    ]
  ])
}