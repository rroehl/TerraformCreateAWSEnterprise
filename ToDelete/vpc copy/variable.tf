variable "RegionMap" { 
  description = "Region maps"
  // Outer Region
  // Inner map key: vpc Name
  // inner map key: vpc object
  // outer map key: AZ Name
  // inner map key: Az map
  // outer map value: inner map
  // inner map key: subnet type
  // inner map value : subnet list
  type = map(  											#region
		object({   										#Region contents

            region_managed_CIDR_list_info =   map(     	# CIDR 
                object({                                # CIDR Lists
                    address_family = string             # Type of entries eg IPv4
                    max_entries = number                # max number of CIDR entries

                    cidr_entries = map( 
                        object({                        # Entry 1
                            cidr_entry = string         # CIDR
                            cidr_description = string   # CIDR description
                        })
                       
                    )
                    
                })
            )

			vpc_info =  map(     						#VPCs
				object({	 							#VPC contents 
					vpc_cidr_block = string
					vpc_environment_type = string //Dev/Test/Prod
					vpc_enable_dns_support = bool
					vpc_enable_dns_hostnames = bool
                    vpc_uuid = string        //Resource UUID
                    default_rt_uuid = string //Default route table UUID
                    default_sg_uuid = string //Default security group UUID
                    default_netacl_uuid = string //Default network acl UUID
				/*	vpc_instance_tenancy = string
					vpc_enable_classiclink_dns_support = bool
					vpc_assign_generated_ipv6_cidr_block = bool
					vpc_enable_classiclink = bool */
                    
                    vpc_cidr_block_list_info =  map(   	#Secondary CIDR blocks
						object({
                            cidr = string               #CIDR Block
                            info = string               # CIDR block info
                        })
                    )
                    
                    network_acls_list_info =   map(     	    # VPC network acls
                        object({                                # network acls Lists   
                            description = string    
                                 subnet_type = string  //Has to match the subnet type name on the subnet  
                            ingress_obj_list = map ( object({ 
                                protocol   = string  // -1: All protocols
                                rule_no    = number
                                action     = string
                                cidr_block = string
                                from_port  = number // 0: forall protocols
                                to_port    = number
                            }) )
                            egress_obj_list = map(  object({ 
                                protocol   = string
                                rule_no    = number
                                action     = string
                                cidr_block = string
                                from_port  = number
                                to_port    = number
                            }) )

                        })
                    )   

                    security_groups_list_info =   map(     	    # VPC Security groups 
                        object({                                # security group Lists
                            description = string
                            ingress = object({ 
                               description      = string
                               from_port        = number
                               to_port          = number
                               protocol         = string
                               cidr_blocks     = list(string)
                               //ipv6_cidr_blocks = list(string)
                            })
                            egress = object({ 
                                from_port        = number
                                to_port          = number
                                protocol         = string 
                                cidr_blocks     = list(string)
                                //ipv6_cidr_blocks = list(string)
                            })
                        })
                    )

                  /*  route_table_info = map (
                        map (
                            list(string)
                        )
                    )*/



					//az_info = map(   					#AZs
					//	map( 							#Subnet types
					//		list(string)  				#subnets
					//	)
					//)  	
                    az_info = map(   					#AZs
						map( 							#Subnet
							object({
                                sn_class_type = string
                                sn_uuid = string
                            })
						)
					) 


				})
			)			
		})
	)
}