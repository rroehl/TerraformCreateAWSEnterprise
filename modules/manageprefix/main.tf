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
// Get the enterprise data structure from common module
module "enterprise_config_module" {
    source = "../common"
    //module.enterprise_config.enterprise_config 
}

variable "vpc_region" {
  type = string
  description = "AWS Region"
  validation {
	condition = ( var.vpc_region == "us-east-2" || var.vpc_region == "us-west-2" || var.vpc_region == "us-west-1" || var.vpc_region == "us-east-1")
	error_message = "Region can be us-east-2 or us-west-2."
    }
} 

//Loop thru managed CIDR lists to retrieve the CIDR list name
locals {
    vpc_managed_CIDR_lists_info = flatten ([
        for region_key, region_obj in module.enterprise_config_module.enterprise_config : [
            for CIDR_list_key, CIDR_list_obj in region_obj.region_managed_CIDR_list_info : {
                vpc_region_name = region_key
                managed_CIDR_list_name = CIDR_list_key  //CIDR_list1
                address_family = CIDR_list_obj.address_family
                cidr_list_uuid = CIDR_list_obj.cidr_list_uuid
                max_entries = CIDR_list_obj.max_entries
                cidr_entries = CIDR_list_obj.cidr_entries
            }   
        ]
   
    ])
}

//Create region managed prefix CIDR lists
resource "aws_ec2_managed_prefix_list" "this" {
  for_each = {
        for list in local.vpc_managed_CIDR_lists_info : "Region: ${list.vpc_region_name} Managed List name: ${list.managed_CIDR_list_name}" => list  if list.vpc_region_name == var.vpc_region
  }
    name           = each.value.managed_CIDR_list_name
    address_family = each.value.address_family 
    max_entries    = each.value.max_entries

    dynamic "entry" {
        for_each = each.value.cidr_entries //cidr_entries
        content {
        cidr = entry.value["cidr_entry"]
        description = entry.value["cidr_description"]
        }
    }

    tags = {
        Region = each.value.vpc_region_name
        "Date_created" = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
        uuid =   each.value.cidr_list_uuid
    }
}