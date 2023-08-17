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
  
#Create SubNetsin US-East-2
module "CreateEnterpriseSubnetsin-US-East-2" {

  source = "../modules/subnet"
  providers = {
    aws = aws.useast2
  }
 vpc_region = "us-east-2"
  
}

