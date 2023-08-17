 terraform {
  required_version = ">= 1.3.7" 
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.49"
    }
  } 
}

provider "aws" {
  profile    = "default"
  region     = "us-west-2"
  alias      = "uswest2"
}

provider "aws" {
  profile    = "default"
  region     = "us-east-2"
  alias      = "useast2"
}
  

//Get the Regions
// for_each = {for region in local.regions :  "${region.region_name}" => region}
//locals {
 // regions =  flatten([
  //  for region_key, region_obj in var.RegionMap : {
    //  region_alias  = "west" #region_obj.region_alias 
   //   region_name = region_key  
   // }
  //])
//}

#Create VPC in US-West-2
/*
module "CreateEnterpriseVPCsin-US-West-2" {
  source = "./modules/vpcsubnet"
  providers = {
    aws = aws.uswest2
  }
 vpc_region = "us-west-2"
 RegionMap = var.RegionMap
}
*/

#Create VPCs in US-East-2
module "CreateEnterpriseVPCsin-US-East-2" {

  source = "../modules/vpc"
  providers = {
    aws = aws.useast2
  }
 vpc_region = "us-east-2"

}

/*
#Create VPC in US-West-2
module "CreateEnterpriseVPCsin-US-West-2" {
  source = "./modules/testmodule"

  providers = {
    aws = aws.uswest2
  }
 
  for_each = {
    for vpc in local.vpcs :  "${vpc.vpc_name}" => vpc if vpc.region_name == "us-west-2"
    }

  vpc_name = each.key
 
  vpc_cidr_block = each.value.vpc_cidr_block
  vpc_enable_dns_support = each.value.vpc_enable_dns_support
  vpc_enable_dns_hostnames = each.value.vpc_enable_dns_hostnames    
  //vpc_instance_tenancy = each.value.vpc_instance_tenancy
	//vpc_enable_classiclink_dns_support = each.value.vpc_enable_classiclink_dns_support
	//vpc_assign_generated_ipv6_cidr_block = each.value.vpc_assign_generated_ipv6_cidr_block
  //vpc_enable_classiclink   = each.value.vpc_enable_classiclink 

  vpc_tags = {
    Region = each.value.region_name
    Environment = each.value.vpc_environment_type
  }
}
*/

#Create VPCs in US-East-2
/*
module "CreateEnterpriseVPCsin-US-East-2" {
  source = "./modules/testmodule"

  providers = {
    aws = aws.useast2
  }
 
  for_each = {
    for vpc in local.vpcs :  "${vpc.vpc_name}" => vpc if vpc.region_name == "us-east-2"
    }

  vpc_name = each.key
 
  vpc_cidr_block = each.value.vpc_cidr_block
  vpc_enable_dns_support = each.value.vpc_enable_dns_support
  vpc_enable_dns_hostnames = each.value.vpc_enable_dns_hostnames    
  //vpc_instance_tenancy = each.value.vpc_instance_tenancy
	//vpc_enable_classiclink_dns_support = each.value.vpc_enable_classiclink_dns_support
	//vpc_assign_generated_ipv6_cidr_block = each.value.vpc_assign_generated_ipv6_cidr_block
  //vpc_enable_classiclink   = each.value.vpc_enable_classiclink 

  vpc_tags = {
    Region = each.value.region_name
    Environment = each.value.vpc_environment_type
  }
}

*/



/*

output "ListVPCsByFor" {
  value = {
     
      for vpc in local.vpcs :  "${vpc.vpc_name}" => vpc 
    
  }
}
*/

/*
output "test" {
  value = var.RegionMap 
}
*/

/*
output "ListRegionsbyFor" {
  value = {
    
      for region in local.regions :  "${region.region_name}" => region
   
  }
}

*/


/*
output "Regions" {
    value =  { 
      for region in local.regions :  "${region.region_name}" => region
    }
}
output "VPCS" {
    value =  { 
      for vpc in local.vpcs :  "${vpc.vpc_name}" => vpc
    }
}
*/


/*
output "VPCSubnetMap" {
    value =  { 
      for subnet in local.vpc_network_subnets :  "${subnet.az_name}.${subnet.cidr_block}" => subnet
    }

}

*/
