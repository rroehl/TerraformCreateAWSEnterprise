### Objective

The objective of the Terraform IaC project is to

* Develop an AWS infrastructure on a local system and not to use Terraform Cloud.
* Look at defining AWS infrastructure in a Terraform hierarchical data structure. It defines all of the AWS resources in the enterprise and is passed into Terraform code to create the infrastructure. By modifying the data structure, and not the code, will allow for changes to the AWS infrastructure.
* Separate the enterprise creation components into separate workspaces. It will minimize the "blast radius" and use AWS as the source of truth for resource IDs and not Terraform state files. There are other ways to perform this function within Terraform; however, in this case the goal was to look at doing it outside of Terraform world.

The purpose of this project is to neither create a production quality code or a full resource set. It is to investigate the pros and cons of such a framework and proof of concept.

### Folder Layout

├── 1.vpc
├── 2.manageprefix
├── 2.securitygroups
├── 2.subnet
├── 3.networkacl
└── modules
├── common
├── manageprefix
├── networkacl
├── securitygroups
├── subnet
└── vpc
Figure 1. Folder structure

The first layer of projects creates the enterprise VPC resources. The second layer creates the managed prefix Lists, Security Groups, and Subnet resources. Lastly the third layer creates Network ACLs resources. The prefix sequence number infer the order of Terraform calling, with 1.VPC  terraform apply being called first.  In layer two, the projects do not have dependency and can be called any order.

Example: To Terraform the VPC resources, execute Terraform plan and apply within the "1.vpc" folder. To create the enterprise subnets execute Terraform plan and apply from within the "2.securitygroups" folder.

Under the modules folder there is:

* The common folder which contains the variable tf file. It defines the hierarchical data structure and its content. The tf file is referenced by all the other modules by the module container construct.
* The vpc folder. The main tf file creates all the VPC resources in a region, the VPC default route tables, the VPC default security group/ingress and egress rules, the VPC default Network ACL lists, and the VPC IP4 CIDR associations.
* The managed prefix list folder and it creates the VPCs Managed Prefix List resources.
* The security groups folder and it creates the enterprise security groups, and the ingress and egress rules.
* The subnet folder which creates all the subnet resources in all of the regions VPCs.
* The network ACL folder which creates the network ACL resources and their ingress and egress rules.

### Data Structure

The Terraform data structure defines all the resources for the enterprise in a hierarchical form.
extensivle
minimal code change

Large data structure
Regions:

    {Region 1 name}:
        region_managed_CIDR_list_info:
            {attributes}
            cidr_entries:
                {cidr entry 1 name}:
                    {attributes}
                {cidr entry 2 name}:
                    {attributes}

        vpc_info:
            {VPC 1 name}:
                {attributes}

                vpc_cidr_block_list_info:
                    {CIDR block 1 name}:
                        {attributes}
                    {CIDR block 2 name}:
                        {attributes}

                network_acls_list_info:
                    {network acls list 1 name}:
                        {attributes}
                        ingress_obj_list:
                            {attributes}
                        egress_obj_list:
                            {attributes}
                    {network acls list 2 name}:
                        {attributes}
                        ingress_obj_list:
                            {attributes}
                        egress_obj_list:
                            {attributes}
                    
                default_security_group_info:
                    {attributes}
                    ingress_obj_list:
                        {ingress rule 1 name}:
                            {attributes}
                        {ingress rule 2 name}:
                            {attributes}
                    egress_obj_list:
                        {egress rule 1 name}:
                            {attributes}
                        {egress rule 2 name}:
                            {attributes}
                
                security_groups_list_info:
                    {security group 1 name}:
                        {attributes}
                        ingress_obj_list:
                            {ingress rule 1 name}:
                                {attributes}
                            {ingress rule 2 name}:
                                {attributes}
                        egress_obj_list:
                            {egress rule 1 name}:
                                {attributes}
                            {egress rule 2 name}:
                                {attributes}
                    {security group 2 name}:
                    {security group 3 name}:

                az_info:
                    {availability zone 1 name}:
                        {CIDR block 1 value}
                            {attributes}
                        {CIDR block 2 value}:
                            {attributes}
                    {availability zone 2 name}:
                    {availability zone 3 name}:

            {VPC 2 name}:
            {VPC 3 name}:
            {VPC 4 name}:
            
    {Region 2 name}:
        region_managed_CIDR_list_info:
            {attributes}
            cidr_entries:
                {cidr entry 1 name}
                {cidr entry 2 name}
        vpc_info:
            {VPC 1 name}
            {VPC 2 name}
            {VPC 3 name
