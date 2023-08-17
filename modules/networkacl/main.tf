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


//Get the VPCs Network ACLs info from structure
locals {
  vpcs_network_acls =  flatten([
    for region_key, region_obj in module.enterprise_config_module.enterprise_config  : [
      for vpc_key, vpc_obj in region_obj.vpc_info :  [
            for network_acls_list_key, network_acls_list_obj in vpc_obj.network_acls_list_info : {
                vpc_region_name = region_key
                vpc_name = vpc_key
                vpc_uuid = vpc_obj.vpc_uuid
                vpc_environment_type = vpc_obj.vpc_environment_type
                vpc_cidr_block = vpc_obj.vpc_cidr_block 
                network_acl_name = network_acls_list_key
                description = network_acls_list_obj.description
                subnet_type = network_acls_list_obj.subnet_type
                netacl_uuid = network_acls_list_obj.netacl_uuid
            }  
       ]
    ]
  ])
}
// Create VPC network acls
resource "aws_network_acl" "CreateNetworkAcls" {
    for_each = {
        for list in local.vpcs_network_acls : "Region: ${list.vpc_region_name} Managed List name: ${list.vpc_name} Network acl name: ${list.network_acl_name}" => list if list.vpc_region_name == var.vpc_region
    }
    vpc_id =  [for key, obj in values(data.aws_vpc.selected).*: obj.id  if obj.tags.uuid== "${each.value.vpc_uuid}"][0] 

    // A list of Subnet IDs by vpc and subnet type to apply the ACL 
    // In a VPC, subnets that are of the same class type will have the Network Acl configured to enable routing. Where as disimmilar network subnets classes will be blocked
    subnet_ids = values(   
        {
          for key, object in data.aws_subnet.subnet_objs : key => object.id 
                    if 
                       (object.vpc_id == [for key, obj in values(data.aws_vpc.selected).*: obj.id  if obj.tags.uuid== "${each.value.vpc_uuid}"][0]) 
                       && 
                        (object.tags["Subnet Class_Type"] == each.value.subnet_type
                      )
        }
    )
    tags = {
        Name = each.value.network_acl_name 
        Description = each.value.description
        Region = each.value.vpc_region_name
        VPC = each.value.vpc_name
        Subnet_Type = each.value.subnet_type
        "Date_created" = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
        uuid =  each.value.netacl_uuid
    } 
}

//Get the VPCs Network ACLs ingress rule info from structure
locals {
  vpcs_network_acls_ingress_rules =  flatten([
    for region_key, region_obj in module.enterprise_config_module.enterprise_config  : [
      for vpc_key, vpc_obj in region_obj.vpc_info :  [
            for network_acls_list_key, network_acls_list_obj in vpc_obj.network_acls_list_info : [
                for rule_key, rule_object in network_acls_list_obj.ingress_obj_list : {
                vpc_region_name = region_key
                vpc_name = vpc_key
                vpc_environment_type = vpc_obj.vpc_environment_type
                vpc_cidr_block = vpc_obj.vpc_cidr_block 
                network_acl_name = network_acls_list_key
                rule = rule_key
                protocol = rule_object.protocol
                rule_no = rule_object.rule_no
                action = rule_object.action
                cidr_block = rule_object.cidr_block
                from_port = rule_object.from_port
                to_port = rule_object.to_port
                }
            ]  
      ]
    ]  
  ])
}

// Create the ingress rules
resource "aws_network_acl_rule" "this" {
    for_each = {
        for list in local.vpcs_network_acls_ingress_rules : "Region: ${list.vpc_region_name} Managed List name: ${list.vpc_name} Network acl name: ${list.network_acl_name} Rule: ${list.rule}" => list if list.vpc_region_name == var.vpc_region
    }
    network_acl_id = lookup(aws_network_acl.CreateNetworkAcls, "Region: ${each.value.vpc_region_name} Managed List name: ${each.value.vpc_name} Network acl name: ${each.value.network_acl_name}").id 
    protocol       = each.value.protocol
    rule_number    = each.value.rule_no
    egress         = false 
    rule_action    = each.value.action
    cidr_block     = each.value.cidr_block
    from_port      = each.value.from_port
    to_port        = each.value.to_port
}

//Get the VPCs Network ACLs egress rule info from structure
locals {
  vpcs_network_acls_egress_rules =  flatten([
    for region_key, region_obj in module.enterprise_config_module.enterprise_config  : [
      for vpc_key, vpc_obj in region_obj.vpc_info :  [
            for network_acls_list_key, network_acls_list_obj in vpc_obj.network_acls_list_info : [
                for rule_key, rule_object in network_acls_list_obj.egress_obj_list : {
                vpc_region_name = region_key
                vpc_name = vpc_key
                vpc_environment_type = vpc_obj.vpc_environment_type
                vpc_cidr_block = vpc_obj.vpc_cidr_block 
                network_acl_name = network_acls_list_key
                rule = rule_key
                protocol = rule_object.protocol
                rule_no = rule_object.rule_no
                action = rule_object.action
                cidr_block = rule_object.cidr_block
                from_port = rule_object.from_port
                to_port = rule_object.to_port
                }
            ]  
      ]
    ]
    
  ])
}
// Create the egress rules
resource "aws_network_acl_rule" "egress" {
    for_each = {
        for list in local.vpcs_network_acls_egress_rules : "Region: ${list.vpc_region_name} Managed List name: ${list.vpc_name} Network acl name: ${list.network_acl_name} Rule: ${list.rule}" => list if list.vpc_region_name == var.vpc_region
    }
    network_acl_id = lookup(aws_network_acl.CreateNetworkAcls, "Region: ${each.value.vpc_region_name} Managed List name: ${each.value.vpc_name} Network acl name: ${each.value.network_acl_name}").id 
    protocol       = each.value.protocol
    rule_number    = each.value.rule_no
    egress         = true 
    rule_action    = each.value.action
    cidr_block     = each.value.cidr_block
    from_port      = each.value.from_port
    to_port        = each.value.to_port
}