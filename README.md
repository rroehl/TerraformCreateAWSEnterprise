## Teraforming AWS Enterpirse (IaC) from a Complex Variable Data Structure

### Objective

The objective of the Terraform IaC project is to

* Develop an AWS infrastructure on a local system and not to use Terraform Cloud.
* Look at defining AWS infrastructure in a Terraform hierarchical data structure. It defines all of the AWS resources in the enterprise and is passed into Terraform code to create the infrastructure. By modifying the data structure, and not the code, will allow for changes to the AWS infrastructure.
* Separate the enterprise creation components into separate workspaces. It will minimize the "blast radius" and use AWS as the source of truth for resource IDs and not Terraform state files. There are other ways to perform this function within Terraform; however, in this case the goal was to look at doing it outside of Terraform world.

The purpose of this project is to neither create a production quality code or a full resource set. It is to investigate the pros and cons of such a framework and proof of concept.

### Folder Layout

    ├── 1.0.manageprefix
    ├── 2.0.vpc
    ├── 3.0.securitygroups
    ├── 3.0.subnet
    ├── 4.0.networkacl
    └── modules
        ├── common
        ├── manageprefix
        ├── networkacl
        ├── securitygroups
        ├── subnet
        └── vpc

Figure 1. Folder structure

The 1.0 layer creates the managed prefix Lists, which depend on the region and not the VPCs. It can be executed in any order. The 2.0 layer of projects creates the enterprise VPC resources, and depends on the region name. The 3.0 layer creates the Security Groups and Subnet resources, and their Terraform scripts can be run concurrently, and only depends on the 2.0 VPC layer. Lastly the 4.0 layer creates Network ACLs resources, and depends on the VPC and Subnet resources. The prefix sequence number, 1.0,2.0.., direct the order of Terraform creation, with 1.0.manage prefix Terraform apply being called first.  In layer 3.0, the projects do not have intra dependency and can be called any order.

Example: To Terraform the VPC resources, execute Terraform plan and apply within the "2..vpc" folder. To create the enterprise subnets execute Terraform plan and apply from within the "3.0.securitygroups" folder.

Under the modules folder there is:

* The common folder which contains the variable tf file. It defines the hierarchical data structure and its content. The tf file is referenced by all the other modules by the module container construct.
* The vpc folder. The main tf file creates all the VPC resources in a region, the VPC default route tables, the VPC default security group/ingress and egress rules, the VPC default Network ACL lists, and the VPC IP4 CIDR associations.
* The managed prefix list folder and it creates the Managed Prefix List resources.
* The security groups folder and it creates the enterprise security groups, and the ingress and egress rules.
* The subnet folder which creates all the subnet resources in all of the regions VPCs.
* The network ACL folder which creates the network ACL resources and their ingress and egress rules.

### Data Structure

The Terraform data structure defines all the resources for the enterprise in a hierarchical form and the  data structure definition and values can be found in the modules/common/variable.tf file. An example can be located there, and it is referenced by the other module tf files when building the infrastructure.
The elements enclosed in curly brackets,{}, are modified during the configuration stage. The non-bracket elements cannot change as they are referenced in the Terraform code. Below is a high level description of the data structure elements:

* Element 1 is the AWS Region. The region name has to match an AWS region name, us-east-1, and the number of region names can be variable.
* Element 2 is the region managed CIDR list configuration. It can configure multiple managed prefix lists, each with multiple prefix CIDR entries.
* Element 3 is the configuration for the VPCs in the region. The VPC name element is the name of the AWS VPC and the structure can support multiple VPC configurations.
* Element 4 is configuration for the VPC CIDR lists and it can configure multiple e CIDR entries for the VPC.
* Element 5 is the configuration for the VPC network ACL list. It will provide the multiple ingress and egress rules for a variable number network ACLs. The network ACL list name is used to configure the AWS network ACL resource name. Note, the default VPC network ACL is not configured with this code.
* Element 6 will configure the VPC's default security group ingress and egress rules.
* Element 7 provides the configuration for the VPC's security groups and the associated ingress/egress rule. The security group name is used to configure the AWS security group name.  

        Regions:                                 <---- Element 1
            {Region 1 name}:
                region_managed_CIDR_list_info:   <---- Element 2
                    {CIDR List 1 name}:
                        {attributes}
                        cidr_entries:
                            {cidr entry 1 name}:
                                {attributes}
                            {cidr entry 2 name}:
                                {attributes}
                    {CIDR List 2 name}:
                        {attributes}
                        cidr_entries:
                            {cidr entry 1 name}:
                                {attributes}

                vpc_info:                        <---- Element 3
                    {VPC 1 name}:
                        {attributes}

                        vpc_cidr_block_list_info: <---- Element 4
                            {CIDR block 1 name}:
                                {attributes}
                            {CIDR block 2 name}:
                                {attributes}

                        network_acls_list_info:  <---- Element 5
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
                            
                        default_security_group_info: <---- Element 6
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
                        
                        security_groups_list_info:  <---- Element 7
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

                        az_info:                         <---- Element 8
                            {availability zone 1 name}:  <---- Element 9
                                {CIDR block 1 value}     <---- Element 10
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
                    {VPC 3 name}
Figure 2

* Element 8 contains all the availability zone and subnets configuration for this VPCs.
* Element 9 are the AWS availability zone names in the structure's availability zone name. The name has to match the AZ's for this region.
* Element 10 are the subnet CIDR values and each one represents a subnet. Under the AZ name element, there can be multiple CIDR subnets. The subnet class type attribute is used categorize the subnet. For an example the class types could be Dev, Test and Prod. The class type can be used to group, name, and tag subnets of a similar class.

### Unique Universal Identifier for AWS Resources
All AWS resource configurations in the data structure have an UUID attribute which is used to configure the AWS resource tag value. Instead of retrieving AWS resource IDs from the Terraform state files, the AWS source is queried by the UUID tag using the Terraform Data Sources. This method assists when referring to resources acerose Terraform workspace boundaries, or referring to a resource that has a new AWS resource ID but the same UUID. There are other ways like exporting the resource IDs from the Terraform state files; however, for this project AWS was defined as the 'source of truth' for the resource IDs.

### Execution Steps

From the below folders:

    ./1.0.manageprefix/
        terraform apply
    ./2.0.vpc/
        terraform apply
    ./3.0.securitygroups/
        terraform apply
    ./3.0.subnet/
        terraform apply
    ./4.0.networkacl/
        terraform apply

### First Impressions

Since the TF variable data structure is extendable, modification to resources is done by updating the data structure in the common variable file and not by updating the Terraform code.

The data structure hierarchical form provides the ability to inherit root resource information in embedded resources, and is demonstrated in the tagging fields. The resource objects embedded in the VPC object can easily get the VPC configuration for their configuration.

Since the data structure is consistent and one set of code is used to Terraform resources, the resources configuration (naming and tagging) is consistent.

The variable data structure becomes large and difficult to manage. However, creative ways can be created to maintain the data structure.