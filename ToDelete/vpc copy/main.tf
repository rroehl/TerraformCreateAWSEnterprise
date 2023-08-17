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

//Get the VPCs info from structure
locals {
  vpcs =  flatten([
    for region_key, region_obj in var.RegionMap : [ 
      for vpc_key, vpc_obj in region_obj.vpc_info :  { 
        region_name = region_key
        vpc_name = vpc_key
        vpc_environment_type = vpc_obj.vpc_environment_type
        vpc_cidr_block = vpc_obj.vpc_cidr_block 
        vpc_enable_dns_support = vpc_obj.vpc_enable_dns_support
        vpc_enable_dns_hostnames = vpc_obj.vpc_enable_dns_hostnames 
        vpc_uuid = vpc_obj.vpc_uuid   
        default_rt_uuid = vpc_obj.default_rt_uuid 
        default_sg_uuid = vpc_obj.default_sg_uuid 
        default_netacl_uuid = vpc_obj.default_netacl_uuid 
        /*vpc_instance_tenancy = vpc_obj.vpc_instance_tenancy
				vpc_enable_classiclink_dns_support = vpc_obj.vpc_enable_classiclink_dns_support
				vpc_assign_generated_ipv6_cidr_block = vpc_obj.vpc_assign_generated_ipv6_cidr_block
        vpc_enable_classiclink   = vpc_obj.vpc_enable_classiclink */
      }  
    ]
  ])
}

#Create a VPCs
resource "aws_vpc" "this" {

  for_each = {
    for vpc in local.vpcs :  "${vpc.vpc_name}" => vpc if vpc.region_name == var.vpc_region
    }
    cidr_block = each.value.vpc_cidr_block
    enable_dns_support= each.value.vpc_enable_dns_support
    enable_dns_hostnames = each.value.vpc_enable_dns_hostnames  
	//instance_tenancy     = each.value.vpc_instance_tenancy
    //enable_classiclink   =  each.value.vpc_enable_classiclink
	//enable_classiclink_dns_support =  each.value.vpc_enable_classiclink_dns_support
	//assign_generated_ipv6_cidr_block =  each.value.vpc_assign_generated_ipv6_cidr_block

    tags = {
      "Name"     = format("%s", each.value.vpc_name)
      Region     = each.value.region_name
      "Environment_Type" = each.value.vpc_environment_type
      "Date_created" = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
      "uuid" = each.value.vpc_uuid
    }
}

#Update default route table for VPCs
resource "aws_default_route_table" "this" {

  for_each = {
    for vpc in local.vpcs :  "${vpc.vpc_name}" => vpc if vpc.region_name == var.vpc_region
    }
    default_route_table_id = lookup(aws_vpc.this, "${each.value.vpc_name}").default_route_table_id

    tags = {
      "Name"     = format("Default-%s-RT", each.value.vpc_name)
      Region     = each.value.region_name
      "Environment_Type" = each.value.vpc_environment_type
      "Date_created" = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
      "uuid" = each.value.default_rt_uuid
    }
}

#Update default security group for VPCs
resource "aws_default_security_group" "this" {

  for_each = {
    for vpc in local.vpcs :  "${vpc.vpc_name}" => vpc if vpc.region_name == var.vpc_region
    }
    vpc_id = lookup(aws_vpc.this, "${each.value.vpc_name}").id 

    tags = {
      "Name"     = format("Default-%s-SG", each.value.vpc_name)
      Region     = each.value.region_name
      "Environment_Type" = each.value.vpc_environment_type
      "Date_created" = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
      "uuid" = each.value.default_sg_uuid
    }
}

#Update default network ACL for VPCs
resource "aws_default_network_acl" "this" {

  for_each = {
    for vpc in local.vpcs :  "${vpc.vpc_name}" => vpc if vpc.region_name == var.vpc_region
    }
    default_network_acl_id = lookup(aws_vpc.this, "${each.value.vpc_name}").default_network_acl_id

    tags = {
      "Name"     = format("Default-%s-netACL", each.value.vpc_name)
      Region     = each.value.region_name
      "Environment_Type" = each.value.vpc_environment_type
      "Date_created" = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
      "uuid" = each.value.default_netacl_uuid
    }
}

//Get the VPCs additional CIDR blocks from structure
locals {
  vpcs_cidr_block_lists =  flatten([
    for region_key, region_obj in var.RegionMap : [
      for vpc_key, vpc_obj in region_obj.vpc_info :  [
            for cidr_block_list_key, cidr_block_list_obj in vpc_obj.vpc_cidr_block_list_info : {
                vpc_region_name = region_key
                vpc_name = vpc_key
                vpc_environment_type = vpc_obj.vpc_environment_type
                vpc_cidr_block = vpc_obj.vpc_cidr_block 
                secondary_cidr_name = cidr_block_list_key
                secondary_cidr = cidr_block_list_obj.cidr
                secondary_cidr_info = cidr_block_list_obj.info

            }  
      ]
    ]
  ])
}

// Create CIDR Blocks
resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
    for_each = {
        for list in   local.vpcs_cidr_block_lists : "Region: ${list.vpc_region_name} Managed List name: ${list.vpc_name}Secondary CIDR  name: ${list.secondary_cidr_name}" => list  if list.vpc_region_name == var.vpc_region
    }
   vpc_id     = lookup(aws_vpc.this, "${each.value.vpc_name}").id 
   cidr_block = each.value.secondary_cidr
}
