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

