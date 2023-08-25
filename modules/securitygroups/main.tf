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
                //vpc_environment_type = vpc_obj.vpc_environment_type
                vpc_cidr_block = vpc_obj.vpc_cidr_block 
                sg_name = security_group_list_key
                sg_description = security_group_list_obj.description
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

        tags = {
            Name = each.value.sg_name
            Region = each.value. vpc_region_name
             "uuid"  = each.value.sg_uuid
            VPC = each.value.vpc_name
            "Date_created" = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
        }
}

//Get the VPCs security group ingress rules from structure
locals {
  vpcs_security_group_ingress_rules =  flatten([
    for region_key, region_obj in module.enterprise_config_module.enterprise_config : [
      for vpc_key, vpc_obj in region_obj.vpc_info :  [
        for security_group_list_key, security_group_list_obj in vpc_obj.security_groups_list_info : [
          for rule_key, rule_object in security_group_list_obj.ingress_obj_list : {
            vpc_region_name = region_key
            vpc_name = vpc_key
            //vpc_uuid = vpc_obj.vpc_uuid
            //vpc_environment_type = vpc_obj.vpc_environment_type
            //vpc_cidr_block = vpc_obj.vpc_cidr_block 
            sg_name = security_group_list_key
            sg_description = security_group_list_obj.description
            sg_uuid = security_group_list_obj.sg_uuid

            rule_name  = rule_key
            description      = rule_object.description
            from_port        = rule_object.from_port
            to_port          = rule_object.to_port
            protocol         = rule_object.protocol 
            cidr_ipv4        = rule_object.cidr_ipv4
          }        
        ]  
      ]
    ]
  ])
}
//Create Security group ingress rules
resource "aws_vpc_security_group_ingress_rule" "this" {

    for_each = {
        for list in local.vpcs_security_group_ingress_rules : "Region: ${list.vpc_region_name} VPC: ${list.vpc_name} Security Group: ${list.sg_name} Rule name: ${list.rule_name}" => list if list.vpc_region_name == var.vpc_region
    }
      security_group_id = lookup(aws_security_group.this, "Region: ${each.value.vpc_region_name} VPC: ${each.value.vpc_name} Security Group: ${each.value.sg_name}").id    
      description = each.value.description
      cidr_ipv4   = each.value.cidr_ipv4
      from_port   = each.value.from_port
      ip_protocol = each.value.protocol
      to_port     = each.value.to_port
      tags = {
        Name = each.value.rule_name
      }
}

//Get the VPCs security group egress rules from structure
locals {
  vpcs_security_group_egress_rules =  flatten([
    for region_key, region_obj in module.enterprise_config_module.enterprise_config : [
      for vpc_key, vpc_obj in region_obj.vpc_info :  [
        for security_group_list_key, security_group_list_obj in vpc_obj.security_groups_list_info : [
          for rule_key, rule_object in security_group_list_obj.egress_obj_list : {
            vpc_region_name = region_key
            vpc_name = vpc_key
            sg_name = security_group_list_key
            sg_description = security_group_list_obj.description
            sg_uuid = security_group_list_obj.sg_uuid

            rule_name  = rule_key
            description      = rule_object.description
            from_port        = rule_object.from_port
            to_port          = rule_object.to_port
            protocol         = rule_object.protocol 
            cidr_ipv4        = rule_object.cidr_ipv4
          }
            
        ]  
      ]
    ]
  ])
}

//Create Security group egress rules
resource "aws_vpc_security_group_egress_rule" "this" {

    for_each = {
        for list in local.vpcs_security_group_egress_rules : "Region: ${list.vpc_region_name} VPC: ${list.vpc_name} Security Group: ${list.sg_name} Rule name: ${list.rule_name}" => list if list.vpc_region_name == var.vpc_region
    }
      security_group_id = lookup(aws_security_group.this, "Region: ${each.value.vpc_region_name} VPC: ${each.value.vpc_name} Security Group: ${each.value.sg_name}").id    
      description = each.value.description
      cidr_ipv4   = each.value.cidr_ipv4
      from_port   = each.value.from_port
      ip_protocol = each.value.protocol
      to_port     = each.value.to_port
      tags = {
        Name = each.value.rule_name
      }
}