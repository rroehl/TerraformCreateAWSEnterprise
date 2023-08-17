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
//Get current region 
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

//Get the VPCs security groupinfo from structure
locals {
  vpcs_security_groups =  flatten([
    for region_key, region_obj in module.enterprise_config_module.enterprise_config : [
      for vpc_key, vpc_obj in region_obj.vpc_info :  [
            for security_group_list_key, security_group_list_obj in vpc_obj.security_groups_list_info : {
                vpc_region_name = region_key
                vpc_name = vpc_key
                vpc_uuid = vpc_obj.vpc_uuid
                vpc_environment_type = vpc_obj.vpc_environment_type
                vpc_cidr_block = vpc_obj.vpc_cidr_block 
                sg_name = security_group_list_key
                sg_description = security_group_list_obj.description
                sg_ingress_description = security_group_list_obj.ingress.description
                sg_ingress_from_port = security_group_list_obj.ingress.from_port
                sg_ingress_to_port = security_group_list_obj.ingress.to_port
                sg_ingress_protocol = security_group_list_obj.ingress.protocol
                sg_ingress_cidr_blocks = security_group_list_obj.ingress.cidr_blocks
                sg_egress_from_port = security_group_list_obj.egress.from_port
                sg_egress_to_port = security_group_list_obj.egress.to_port
                sg_egress_protocol = security_group_list_obj.egress.protocol
                sg_egress_cidr_blocks = security_group_list_obj.egress.cidr_blocks
                sg_uuid = security_group_list_obj.sg_uuid
            }  
      ]
    ]
  ])
}

// Create security groups for VPCs
resource "aws_security_group" "this" {
    for_each = {
        for list in local.vpcs_security_groups : "Region: ${list.vpc_region_name} VPC: ${list.vpc_name} Security Group: ${list.sg_name}" => list  if list.vpc_region_name == var.vpc_region
    }

        name        = each.value.sg_name
        description = each.value.sg_description
        vpc_id      =  [for key, obj in values(data.aws_vpc.selected).*: obj.id  if obj.tags.uuid== "${each.value.vpc_uuid}"][0] 

        ingress {
            description      = each.value.sg_ingress_description
            from_port        = each.value.sg_ingress_from_port
            to_port          = each.value.sg_ingress_to_port
            protocol         = each.value.sg_ingress_protocol 
            cidr_blocks      = each.value.sg_ingress_cidr_blocks
        }

        egress {
            from_port        = each.value.sg_egress_from_port
            to_port          = each.value.sg_egress_to_port
            protocol         = each.value.sg_egress_protocol
            cidr_blocks      = each.value.sg_egress_cidr_blocks
        }

        tags = {
            Name = each.value.sg_name
            Region = each.value. vpc_region_name
             "uuid"  = each.value.sg_uuid
            VPC = each.value.vpc_name
            "Date_created" = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
        }
}
