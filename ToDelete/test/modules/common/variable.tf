variable "enterprise_config" {
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


// Below is the enterprise configuration data

  default =  {

        us-west-2 = { # Region

            # Region CIDR lists
            region_managed_CIDR_list_info = {

               ProdPublicVPC_CIDRlist  = {
                   address_family = "IPv4"
                   max_entries = 4
                   cidr_entries = {
                       entry1 = {
                            cidr_entry = "10.51.0.0/24"
                            cidr_description = "Production Public us-west-2a VPC CIDR"
                        },
                        entry2 = {
                            cidr_entry = "10.51.1.0/24"
                            cidr_description = "Production Public us-west-2a VPC CIDR"
                        },
                        entry3 = {
                            cidr_entry = "10.51.2.0/24"
                            cidr_description = "Production Public us-west-2a VPC CIDR"
                        },
                        entry4 = {
                            cidr_entry = "10.51.3.0/24"
                            cidr_description = "Production Public us-west-2a VPC CIDR"
                        }

                    }
                },
                ProdVPC_CIDRlist  = {
                   address_family = "IPv4"
                   max_entries = 5
                   cidr_entries = {
                       entry1 = {
                            cidr_entry = "10.54.127.0/24"
                            cidr_description = " Long Description"
                        },
                        entry2 = {
                            cidr_entry = "10.54.128.0/24"
                            cidr_description = " short Description"
                        }

                    }

                },
                TestVPC_CIDRlist  = {
                   address_family = "IPv4"
                   max_entries = 5
                   cidr_entries = {
                       entry1 = {
                            cidr_entry = "10.54.127.0/24"
                            cidr_description = " Long Description"
                        },
                        entry2 = {
                            cidr_entry = "10.54.128.0/24"
                            cidr_description = " short Description"
                        }

                    }
                },
                SharedServersVPC_CIDRlist  = {
                   address_family = "IPv4"
                   max_entries = 5
                   cidr_entries = {
                       entry1 = {
                            cidr_entry = "10.54.127.0/24"
                            cidr_description = " Long Description"
                        },
                        entry2 = {
                            cidr_entry = "10.54.128.0/24"
                            cidr_description = " short Description"
                        }

                    }
                },
                SandboxVPC_CIDRlist  = {
                   address_family = "IPv4"
                   max_entries = 5
                   cidr_entries = {
                       entry1 = {
                            cidr_entry = "10.54.127.0/24"
                            cidr_description = " Long Description"
                        },
                        entry2 = {
                            cidr_entry = "10.54.128.0/24"
                            cidr_description = " short Description"
                        }

                    }
                }
            }


		    # Region VPCs
			vpc_info = {
				ProdVPC = {   # VPC
					vpc_cidr_block = "10.51.0.0/16"
					vpc_environment_type = "Prod"
					vpc_enable_dns_support = true
					vpc_enable_dns_hostnames = true
                    vpc_uuid = "b5f01daa-f634-46c4-bc17-243ea0dec212"
                    default_rt_uuid = "8b7feed0-91b4-486e-8b27-4328dae34e23"
                    default_sg_uuid = "4d49f4a9-7660-4288-a52b-8ecda51b0135"
                    default_netacl_uuid = "5fe4b3af-9203-4a31-98dd-68e22bf3de21"
					/*vpc_instance_tenancy = "default"
					vpc_enable_classiclink_dns_support = false
					vpc_assign_generated_ipv6_cidr_block = false
					vpc_enable_classiclink = false*/

                    vpc_cidr_block_list_info = {

                    }    
                    network_acls_list_info = {
                    }      
             

                    security_groups_list_info=  {  # VPC Security groups 

                        ProdVPCpublicsg1 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.0.0/24","10.51.1.0/24","10.51.2.0/24","10.51.3.0/24"]
                               // ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //ipv6_cidr_blocks = ["::/0"]
                            } 
                        },
                        ProdVPCprivatesg2 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.4.0/24","10.51.5.0/24",  "10.51.6.0/24","10.51.7.0/24", "10.51.8.0/24"]
                                //ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //pv6_cidr_blocks = ["::/0"]
                            }
                        }       
                    }	
					az_info = {
						us-west-2a = { # Availability Zone
                            // Public
							"10.51.0.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "3d94bfbc-afd4-4f20-9527-215d849cbbcd"    
                            },
                            "10.51.1.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "143c4e5c-2afe-42eb-ac23-f36fafecc33c"    
                            },
							// Private
							"10.51.4.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "0b35cdfa-15a8-46ed-9232-f23b4a961701"    
                            },
                            "10.51.5.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "10d36cf3-40d4-4360-b37e-bcf363ea05d1"    
                            },
							//Network 
							"10.51.60.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "65b951f9-9844-4bba-a27b-bd284dfe77f5"    
                            },
                            "10.51.61.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "2bac05c9-4d3a-45f7-8398-7f81362c39e4"    
                            },
                            "10.51.62.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "5874363a-9e80-4eac-96fd-e2093252a14a"    
                            },
                            "10.51.63.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "cbb2cfe8-f1ab-4135-ab4c-78b8c91cc95a"    
                            }
							
						},
						us-west-2b = {  # Availability Zone
							//Public 
								"10.51.64.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "56c3044c-5b32-4432-9022-8217523b3433"    
                            },
                            "10.51.65.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "6f75724d-242a-42a9-ab35-bd0efc9250b0"    
                            },
							//Private
							"10.51.68.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "7697a7f5-a96d-422e-a1c5-b31a0495086a"    
                            },
                            "10.51.69.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "d22f9989-8044-416f-a96d-ebb896d781ef"    
                            },
								
							//Network 
							"10.51.124.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "d5554f3d-964a-45fc-86d3-97146742f22e"    
                            }
								
						},
						us-west-2c = {  # Availability Zone
							//Public                           
                            "10.51.128.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "9472b737-9fb3-48cc-ac1b-7ca669be53a9"    
                            },
                            "10.51.129.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "5bd5178d-9894-45c3-90cd-bc8f0351eb0d"    
                            },
								
							//Private 
							"10.51.132.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "4fc36300-d600-4014-8750-17fe61d86436"    
                            },
							//Network 
							"10.51.189.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "5ed8e11c-121a-4f0f-a9c6-cad6fbf262a0"    
                            }
								
						}
					}
				},
				TestVPC = {  # VPC
					vpc_cidr_block = "10.52.0.0/16"
					vpc_environment_type ="Test"
					vpc_enable_dns_support = true
					vpc_enable_dns_hostnames = true
                    vpc_uuid = "0cea34d1-8602-430b-bfdf-3f9529882dc9"
                    default_rt_uuid = "606fddc9-5923-4001-af5a-111f471a5994"
                    default_sg_uuid = "c0765a43-e6f1-403c-ba8e-065b89b96052"
                    default_netacl_uuid = "7da41cad-7915-4649-943f-a821fd5846c0"
					/*vpc_instance_tenancy = "default"
					vpc_enable_classiclink_dns_support = false
					vpc_assign_generated_ipv6_cidr_block = false	
					vpc_enable_classiclink = false */

                    vpc_cidr_block_list_info = {

                    }    
                    network_acls_list_info = {
                    }                      

                    security_groups_list_info=  {  # VPC Security groups 

                        publicsg1 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.0.0/24","10.51.1.0/24","10.51.2.0/24","10.51.3.0/24"]
                               // ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //ipv6_cidr_blocks = ["::/0"]
                            } 
                        },
                        privatesg2 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.4.0/24","10.51.5.0/24",  "10.51.6.0/24","10.51.7.0/24", "10.51.8.0/24"]
                                //ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //pv6_cidr_blocks = ["::/0"]
                            }
                        }
                            
                    }
					
					az_info = {

						us-west-2a = {  # Availability Zone
                             // Public
							"10.52.0.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "de5fbb57-d8a1-43d1-aa30-8e23024d9172"    
                            },
                            "10.52.1.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "d47757d1-b2d0-4911-a5c6-6b4b5046c63b"    
                            },
							// Private 
							"10.52.4.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "724f4131-06d3-47e4-ab07-60d3b6d438e2"    
                            },
                            "10.52.5.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "f6db87d9-5b08-49d4-8143-df5cb96d5c74"    
                            },
							//Network
							"10.52.60.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "817f166c-c70a-4f82-b717-0a644546a946"    
                            }
								
						},
						us-west-2b = {  # Availability Zone
							    // Public
							"10.52.64.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "6fc99d89-1cb6-4e9f-b806-acee0598320f"    
                            },
                            "10.52.65.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "0ae6fb37-4fb3-41f5-b4ae-6a8ba934bf23"    
                            },
							// Private
							"10.52.68.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "dd4dbaf1-10d6-46f3-878d-ac12c05757e4"    
                            },
                            "10.52.69.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "b75f014a-3975-4bba-bed2-0e6a9ea0f2a4"    
                            },
							//Network 
							"10.52.124.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "13f00fca-a0d2-48c7-a908-83309c513944"    
                            }
							
						},
						us-west-2c = {  # Availability Zone
							//Public
							"10.52.128.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "086659ff-f42d-4a67-9e1f-0039231ba308"    
                            },
                            "10.52.129.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "babc35b9-7cf5-4354-a478-1571808d1d6e"    
                            },
							// Private 
							"10.52.132.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "966af2fd-b2e3-46c9-97d8-8e8f1bef1609"    
                            },
                            "10.52.133.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "fd3ce10e-7b3c-4812-bc63-9b6aeb12a3aa"    
                            },
                            // Network
						    "10.52.189.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "06a3f121-9552-4fa9-bb1a-cbfb8d6049e8"    
                            }
						}
					}
				},
				DevVPC = {   # VPC
					vpc_cidr_block = "10.53.0.0/16"
					vpc_environment_type = "Dev"
					vpc_enable_dns_support = true
					vpc_enable_dns_hostnames = true
                    vpc_uuid = "f8010eff-d22b-4e15-8533-4283be6ba65a"
                    default_rt_uuid = "6ce519ba-f718-4574-81f8-ebeaaa983227"
                    default_sg_uuid = "2869a757-53e9-4129-9dbd-5425de8f911f"
                    default_netacl_uuid = "a6d77e80-9931-4121-8bdc-64b2ce627c60"
					/*vpc_instance_tenancy = "default"
					vpc_enable_classiclink_dns_support = false
					vpc_assign_generated_ipv6_cidr_block = false
					vpc_enable_classiclink = false */

                    vpc_cidr_block_list_info = {

                    }    
                    network_acls_list_info = {
                    }                      

                    security_groups_list_info=  {  # VPC Security groups 

                        DevVPCpublicsg1 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.0.0/24","10.51.1.0/24","10.51.2.0/24","10.51.3.0/24"]
                               // ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //ipv6_cidr_blocks = ["::/0"]
                            } 
                        },
                        DevVPCprivatesg2 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.4.0/24","10.51.5.0/24",  "10.51.6.0/24","10.51.7.0/24", "10.51.8.0/24"]
                                //ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //pv6_cidr_blocks = ["::/0"]
                            }
                        }
                            
                    }
					
					az_info = {

						us-west-2a = {   # Availability Zone
							//Public
							"10.53.0.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "45ba8cc2-34fe-4d13-93e7-bb081c9c0108"    
                            },
                            "10.53.1.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "99b25aec-a357-40ba-91a7-8985b3bbb923"    
                            },
							//Private 
							"10.53.4.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "cad759c1-5f30-41ba-bc2f-51668b831a72"    
                            },
                            "10.53.5.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "2eb4cc3c-6674-42f0-9ee0-a241127e2dda"    
                            },
							//Network
							"10.53.60.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "690ea966-b272-4d8f-ba23-095048aa952c"    
                            }
						},
						us-west-2b = {   # Availability Zone
							//Public
							"10.53.64.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "bf1d5273-b172-402e-b090-aea4a526cfa4"    
                            },
                            "10.53.65.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "8d3c656b-35cc-4056-b101-3129117491f1"    
                            },
							//Private
							"10.53.68.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "e38e710e-4df1-4dc6-8197-acb9a7872c0c"    
                            },
                            "10.53.69.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "87652ba7-a768-4322-ae72-7e577f0998d0"    
                            },
							//Network
							"10.53.124.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "1177f4d9-7460-450b-be15-e09f85133c25"    
                            }	
						},
						us-west-2c = {  # Availability Zone
							//Public
							"10.53.128.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "3b65a8c2-9d10-406b-ac68-2a6ae7aa1d25"    
                            },
                            "10.53.129.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "2cc66e69-4fc9-4705-bc7b-bc6f5ba238e6"    
                            },
							//Private 
							"10.53.132.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "1ee078c1-f0ce-49b1-9b4d-cae8ca62da62"    
                            },
                            "10.53.133.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "548466bc-ca71-4a72-b242-de8730e3fd31"    
                            },
							//Network
						    "10.53.189.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "4b2aec18-e90b-4726-a19d-ad1b766afd5b"    
                            }
						}

					}
				},

                SharedServiceVPC = {   # VPC
					vpc_cidr_block = "10.54.0.0/16"
					vpc_environment_type = "Prod"
					vpc_enable_dns_support = true
					vpc_enable_dns_hostnames = true
                    vpc_uuid = "69504008-8545-4023-a227-d3263393c84a"
                    default_rt_uuid = "be09f266-9100-4c61-b7b6-e05cfa86ac2d"
                    default_sg_uuid = "b7c3845d-8391-49f4-8599-eb70d53cd667"
                    default_netacl_uuid = "4a4e4905-be92-4ff8-931e-e3d0c1373d60"
					/*vpc_instance_tenancy = "default"
					vpc_enable_classiclink_dns_support = false
					vpc_assign_generated_ipv6_cidr_block = false
					vpc_enable_classiclink = false */

                    vpc_cidr_block_list_info = {

                    }    
                    network_acls_list_info = {
                    }                      

                    security_groups_list_info=  {  # VPC Security groups 

                        SharedServiceVPCpublicsg1 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.0.0/24","10.51.1.0/24","10.51.2.0/24","10.51.3.0/24"]
                               // ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //ipv6_cidr_blocks = ["::/0"]
                            } 
                        },
                        SharedServiceVPCprivatesg2 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.4.0/24","10.51.5.0/24",  "10.51.6.0/24","10.51.7.0/24", "10.51.8.0/24"]
                                //ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //pv6_cidr_blocks = ["::/0"]
                            }
                        }
                            
                    }
					
					az_info = {

						us-west-2a = {   # Availability Zone
							// Public
								"10.54.0.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "58a64e63-a602-45d1-be18-bd065f22152c"    
                            },
							//Private
								"10.54.4.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "9280b2ef-e0bb-4ba6-b394-711a7c86a8c2"    
                            },
							//Network
								"10.54.60.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "4f360033-a69b-4405-9b96-4a69b675872d"    
                            }
						},
						us-west-2b = {   # Availability Zone
							//Public
								"10.54.64.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "1e78a539-64a6-40ba-9491-7d8906d18e8e"    
                            },
							//Private
								"10.54.68.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "feb758cc-8556-4e4d-952a-4e5dd1737249"    
                            },
							//Network
								"10.54.124.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "a32bfedd-7fe3-4626-8a38-25658ef6677f"    
                            }
						},
						us-west-2c = {  # Availability Zone
							//Public
								"10.54.128.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "7f7c4ac9-926f-4548-bc85-7d593dcd5c14"    
                            },
							//Private
								"10.54.132.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "59092f21-3239-4af4-a985-a8ca0dddeb8e"    
                            },
							//Network
								"10.54.189.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "dfea3bc0-e7cf-43ca-918d-9f433abb47b9"    
                            }
						}

					}
				},
                SandBoxVPC = {   # VPC
					vpc_cidr_block = "10.56.0.0/16"
					vpc_environment_type = "Dev"
					vpc_enable_dns_support = true
					vpc_enable_dns_hostnames = true
                    vpc_uuid = "3c931519-0fe9-4080-a729-5490397d8785"
                    default_rt_uuid = "50a01a33-6ea1-413e-8c3b-cc66139e506c"
                    default_sg_uuid = "414e015a-f0e9-486a-a386-3df8bf0740c4"
                    default_netacl_uuid = "537c95d6-8979-444d-ba23-bc7bede5be6e"
					/*vpc_instance_tenancy = "default"
					vpc_enable_classiclink_dns_support = false
					vpc_assign_generated_ipv6_cidr_block = false
					vpc_enable_classiclink = false */


                    vpc_cidr_block_list_info = {

                    }    
                    network_acls_list_info = {
                    }                      

                    security_groups_list_info=  {  # VPC Security groups 

                        SandBoxVPCpublicsg1 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.0.0/24","10.51.1.0/24","10.51.2.0/24","10.51.3.0/24"]
                               // ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //ipv6_cidr_blocks = ["::/0"]
                            } 
                        },
                        SandBoxVPCprivatesg2 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.4.0/24","10.51.5.0/24",  "10.51.6.0/24","10.51.7.0/24", "10.51.8.0/24"]
                                //ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //pv6_cidr_blocks = ["::/0"]
                            }
                        }        
                    }
					
					az_info = {

						us-west-2a = {   # Availability Zone
							//Public 
							"10.56.0.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "ed59595e-9a0d-4ede-abd4-a4adff620f8b"    
                            },
                            "10.56.1.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "3a029494-27d4-4892-8a1c-450188928996"    
                            },
							//Private
							"10.56.4.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "cf3dd480-57e4-4fe2-99ad-73d32efe1ca0"    
                            },
                            "10.56.5.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "00c3264f-0075-494e-8a07-91eada6fa4f8"    
                            },
							// Network
							"10.56.60.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "305ec51b-5608-4523-9ec0-3bb31c28a866"    
                            }
						},
						us-west-2b = {   # Availability Zone
							//Public 
                            "10.56.64.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "ac254304-0e02-4bb5-bec2-3ab56119e407"    
                            },
                            "10.56.65.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "bab91164-7b6b-4a79-9d16-360b8f746611"    
                            }, 
                            //Private 
							"10.56.68.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "44d1d903-3a3e-45de-8659-ca0946f5f3dc"    
                            },
                            "10.56.69.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "76330e5c-e05b-48f0-b525-c0c9b91a4ce2"    
                            },
							//Network
								"10.56.124.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "907f0f52-9326-4e23-8323-2afd38b7da3e"    
                            }
						},
						us-west-2c = {  # Availability Zone
							//Public 
                            "10.56.128.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "dbb085e3-22e8-466a-a47b-afd6cd75e0ef"    
                            },
                            "10.56.129.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "e1108a82-5784-453d-9d3a-ab1550456108"    
                            },
							//Private
							"10.56.132.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "4c67dcbc-ee7e-4060-9880-e1fe8596328e"    
                            },
                            "10.56.133.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "9f1f1006-236c-4187-b644-33e0c0e80298"    
                            },
						//Network
							"10.56.189.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "b6c73aa1-4c34-4156-9c07-6c51789dc475"    
                            }
						}
					}
				}
			}
		},
	
        us-east-2 = { # Region

            # Region CIDR lists
            region_managed_CIDR_list_info = {

                ProdPublicVPC_CIDRlist  = {
                   address_family = "IPv4"
                   max_entries = 12
                   cidr_entries = {
                       entry1 = {
                            cidr_entry = "10.57.0.0/24"
                            cidr_description = "Production Public us-east-2a VPC Subnet"
                        },
                        entry2 = {
                            cidr_entry = "10.57.1.0/24"
                            cidr_description = "Production Public us-east-2a VPC SubNet"
                        },
                        entry3 = {
                            cidr_entry = "10.57.2.0/24"
                            cidr_description = "Production Public us-east-2a VPC Subnet"
                        },
                        entry4 = {
                            cidr_entry = "10.57.3.0/24"
                            cidr_description = "Production Public us-east-2a VPC Subnet"
                        },
                         entry5 = {
                            cidr_entry = "10.57.64.0/24"
                            cidr_description = "Production Public us-east-2b VPC Subnet"
                        },
                        entry6 = {
                            cidr_entry = "10.57.65.0/24"
                            cidr_description = "Production Public us-east-2b VPC SubNet"
                        },
                        entry7 = {
                            cidr_entry = "10.57.66.0/24"
                            cidr_description = "Production Public us-east-2b VPC Subnet"
                        },
                        entry8 = {
                            cidr_entry = "10.57.67.0/24" 
                            cidr_description = "Production Public us-east-2b VPC Subnet"
                        },
                        entry9 = {
                            cidr_entry = "10.57.128.0/24"
                            cidr_description = "Production Public us-east-2c VPC SubNet"
                        },
                        entry10 = {
                            cidr_entry = "10.57.129.0/24"
                            cidr_description = "Production Public us-east-2c VPC Subnet"
                        },
                        entry11 = {
                            cidr_entry = "10.57.130.0/24"
                            cidr_description = "Production Public us-east-2c VPC Subnet"
                        },
                        entry12 = {
                            cidr_entry = "10.57.131.0/24"
                            cidr_description = "Production Public us-east-2c VPC Subnet"
                        }
                    }
                },

                ProdPrivateVPC_CIDRlist  = {
                    address_family = "IPv4"
                    max_entries = 14
                    cidr_entries = {
                       entry1 = {
                            cidr_entry = "10.58.4.0/24"
                            cidr_description = "Production Private us-east-2a VPC Subnet"
                        },
                        entry2 = {
                            cidr_entry = "10.58.5.0/24"
                            cidr_description = "Production Private us-east-2a VPC SubNet"
                        },
                        entry3 = {
                            cidr_entry = "10.58.6.0/24"
                            cidr_description = "Production Private us-east-2a VPC Subnet"
                        },
                        entry4 = {
                            cidr_entry = "10.58.7.0/24"
                            cidr_description = "Production Private us-east-2a VPC Subnet"
                        },
                         entry5 = {
                            cidr_entry = "10.58.8.0/24"
                            cidr_description = "Production Private us-east-2a VPC Subnet"
                        },
                        entry6 = {
                            cidr_entry = "10.58.68.0/24"
                            cidr_description = "Production Private us-east-2b VPC SubNet"
                        },
                        entry7 = {
                            cidr_entry = "10.58.69.0/24"
                            cidr_description = "Production Private us-east-2b VPC Subnet"
                        },
                        entry8 = {
                            cidr_entry = "10.58.70.0/24"
                            cidr_description = "Production Private us-east-2b VPC Subnet"
                        },
                        entry9 = {
                            cidr_entry = "10.58.71.0/24"
                            cidr_description = "Production Private us-east-2b VPC SubNet"
                        },
                        entry10 = {
                            cidr_entry = "10.58.72.0/24"
                            cidr_description = "Production Private us-east-2b VPC Subnet"
                        },
                        entry11 = {
                            cidr_entry = "10.58.132.0/24" 
                            cidr_description = "Production Private us-east-2c VPC Subnet"
                        },
                        entry12 = {
                            cidr_entry = "10.58.133.0/24"
                            cidr_description = "Production Private us-east-2c VPC Subnet"
                        },
                        entry13 = {
                            cidr_entry =  "10.58.134.0/24" 
                            cidr_description = "Production Private us-east-2c VPC Subnet"
                        },
                        entry14 = {
                            cidr_entry = "10.58.135.0/24"
                            cidr_description = "Production Private us-east-2c VPC Subnet"
                        }
                    }
                }, 

                ProdNetworkVPC_CIDRlist  = {
                   address_family = "IPv4"
                   max_entries = 11
                   cidr_entries = {
                       entry1 = {
                            cidr_entry = "10.59.60.0/24"
                            cidr_description = "Production Network us-east-2a VPC Subnet"
                        },
                        entry2 = {
                            cidr_entry = "10.59.61.0/24"
                            cidr_description = "Production Network us-east-2a VPC SubNet"
                        },
                        entry3 = {
                            cidr_entry = "10.59.62.0/24"
                            cidr_description = "Production Network us-east-2a VPC Subnet"
                        },
                        entry4 = {
                            cidr_entry = "10.59.63.0/24"
                            cidr_description = "Production Network us-east-2a VPC Subnet"
                        },
                         entry5 = {
                            cidr_entry = "10.59.124.0/24"
                            cidr_description = "Production Network us-east-2b VPC Subnet"
                        },
                        entry6 = {
                            cidr_entry = "10.59.125.0/24"
                            cidr_description = "Production Network us-east-2b VPC SubNet"
                        },
                        entry7 = {
                            cidr_entry = "10.59.126.0/24"
                            cidr_description = "Production Network us-east-2b VPC Subnet"
                        },
                        entry8 = {
                            cidr_entry = "10.59.127.0/24"
                            cidr_description = "Production Network us-east-2b VPC Subnet"
                        },
                        entry9 = {
                            cidr_entry = "10.59.189.0/24"
                            cidr_description = "Production Network us-east-2c VPC SubNet"
                        },
                        entry10 = {
                            cidr_entry = "10.59.190.0/24"
                            cidr_description = "Production Network us-east-2c VPC Subnet"
                        },
                        entry11 = {
                            cidr_entry = "10.59.191.0/24"
                            cidr_description = "Production Network us-east-2c VPC Subnet"
                        }
                    }
                }
            },
             
			vpc_info = {
				ProdVPC = {   # VPC
					vpc_cidr_block = "10.45.0.0/16"
					vpc_environment_type = "Prod"
					vpc_enable_dns_support = true
					vpc_enable_dns_hostnames = true
                    vpc_uuid = "5f68a866-029b-4ed3-a91b-657fb47fe89e"
                    default_rt_uuid = "f54ade67-59ff-44f0-85de-b706f317b53b"
                    default_sg_uuid = "61fd47f4-6e64-4af6-842d-a38c3b1e34bb"
                    default_netacl_uuid = "88e5f179-f7e7-4225-9ac9-519e5c861c2e"
					/*vpc_instance_tenancy = "default"
					vpc_enable_classiclink_dns_support = false
					vpc_assign_generated_ipv6_cidr_block = false
					vpc_enable_classiclink = false*/

                    vpc_cidr_block_list_info = { //Additional VPC CIDRs
                        publicCIDR = {
                            cidr = "10.57.0.0/16"
                            info = "public"
                        },
                        privateCIDR = {
                            cidr = "10.58.0.0/16"
                            info = "private"
                        },
                        networkCIDR = {
                            cidr = "10.59.0.0/16"
                            info = "network"
                        }                     
                    }     

                     network_acls_list_info = {  // These are the network accles for the VPC
                        Public_network_acls = {  // 
                            description = "For prod VPC, this will route all traffic between the public networks in the VPC"
                            subnet_type = "Public"  //Has to match the subnet type name on the subnet
                            ingress_obj_list = {  // 
                                ingress_rule1 = { //Allow all traffic inbound from other public networks in the Prod VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.57.0.0/16" //Production public CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                            egress_obj_list = {
                                egress_rule1 = {  //Allow all traffic outbound from other public networks in the Prod VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.57.0.0/16" //Production public CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                        } ,
                        Private_network_acls = {
                            description = "For prod VPC, this will route all traffic between the private networks in the VPC"
                            subnet_type = "Private"  //Has to match the subnet type name on the subnet
                            ingress_obj_list = {  // 
                                ingress_rule1 = { //Allow all traffic inbound from other private networks in the Prod VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.58.0.0/16" //Production private CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                            egress_obj_list = {
                                egress_rule1 = {  //Allow all traffic outbound from other private networks in the Prod VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.58.0.0/16" //Production private CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                        },
                        Network_network_acls = {
                            description = "For prod VPC, this will route all traffic between the network networks in the VPC"
                            subnet_type = "Network"  //Has to match the subnet type name on the subnet
                            ingress_obj_list = {  // 
                                ingress_rule1 = { //Allow all traffic inbound from other network networks in the Prod VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.59.0.0/16" //Production network CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                            egress_obj_list = {
                                egress_rule1 = {  //Allow all traffic outbound from other network networks in the Prod VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.59.0.0/16" //Production network CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                        } 
                    }                    

                    security_groups_list_info=  {  # VPC Security groups 

                        ProdVPCpublicsg1 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.0.0/24","10.51.1.0/24","10.51.2.0/24","10.51.3.0/24"]
                               // ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //ipv6_cidr_blocks = ["::/0"]
                            } 
                        },
                        ProdVPCprivatesg2 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.4.0/24","10.51.5.0/24",  "10.51.6.0/24","10.51.7.0/24", "10.51.8.0/24"]
                                //ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //pv6_cidr_blocks = ["::/0"]
                            }
                        }   
                    }

/*
                    route_table_info =  {

                        route_table_1 = {
                            Type1 = [
								"1","2","13"
								]
                        },
                         route_table_2 = {
                            Type2 = [
								"4","5","6"
								]
                        }
                    },
    */
					az_info = {

						us-east-2a = { # Availability Zone
							//Public
							"10.57.0.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "b8a284ff-fc43-4a84-a97c-9582bf9712fe"    
                            },
                            "10.57.1.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "bcb0f91d-3c41-4dac-8cb0-c33287d8f637"    
                            },
                            "10.57.2.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "5698af97-4a75-454c-a5b0-05bdac0c4d0b"    
                            },
							//Private
							"10.58.4.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "2b68db88-11e3-4224-b4b5-3bb7ccd222fe"    
                            },
                            "10.58.5.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "7620f817-e257-45f4-a52f-47471570dbe8"    
                            },  
                            "10.58.6.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "4e096ef7-f61b-4e81-8d60-a14a708ba8cb"    
                            },
							//Network
							"10.59.60.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "87d5c9ff-7417-49f3-9825-d7d54520b6da"    
                            }
						},
						us-east-2b = {  # Availability Zone
							//public
                            "10.57.64.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "775af36b-c4b3-4590-a43a-570cfcf11b3a"    
                            },
                            "10.57.65.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "3c6e99c6-d499-45b6-bcb4-4dcdc4c81946"    
                            },
                            "10.57.66.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "4d9d9754-5d3b-47bd-8eb6-d1625dd459b1"    
                            },
							//Private
							"10.58.68.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "469f2177-0a5b-44a3-8f18-e220487c3965"    
                            },
                            "10.58.69.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "7d12a40e-2685-4781-9ead-24990426b388"    
                            },
                            "10.58.70.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "d4dcbfab-6a4e-4625-a17f-0a9e4b3bf90b"    
                            },
							//Network
							"10.59.124.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "e82c64cd-5a6f-4288-b556-b3e5720bff99"    
                            }
						},
						us-east-2c = {  # Availability Zone
							//Public
                            "10.57.128.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "9a68b2c6-34ed-4190-867b-665cdc8eb874"    
                            },
                            "10.57.129.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "3a4b8989-8c5a-4653-be21-7deb79084cf0"    
                            },
							//Private
							"10.58.132.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "76e5523f-5c54-4ede-a9eb-a78d6f2399d2"    
                            },
                            "10.58.133.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "45d1d923-1985-443d-9192-fa78ad6a89e1"    
                            },
							//Network
							"10.59.189.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "a8c11203-046e-4084-b386-b2d183776f7d"    
                            }
						} 
					}
				},
				TestVPC = {  # VPC
					vpc_cidr_block = "10.46.0.0/16"
					vpc_environment_type ="Test"
					vpc_enable_dns_support = true
					vpc_enable_dns_hostnames = true
                    vpc_uuid = "dda69f2e-7e96-481a-88a1-5101dc1a1b6e"
                    default_rt_uuid = "01272144-0319-4de7-b79e-72c304f1d69d"
                    default_sg_uuid = "29a99c68-a689-41eb-b80b-25bafe7a8db7"
                    default_netacl_uuid = "948420e5-92ba-4591-988d-2b29d1f97d16"
					/*vpc_instance_tenancy = "default"
					vpc_enable_classiclink_dns_support = false
					vpc_assign_generated_ipv6_cidr_block = false	
					vpc_enable_classiclink = false */

                    vpc_cidr_block_list_info = { //Additional VPC CIDRs
                        publicCIDR = {
                            cidr = "10.60.0.0/16"
                            info = "public"
                        },
                        privateCIDR = {
                            cidr = "10.61.0.0/16"
                            info = "private"
                        },
                        networkCIDR = {
                            cidr = "10.62.0.0/16"
                            info = "network"
                        }                     
                    }  

                    network_acls_list_info = {  // These are the network acls for the VPC
                        Public_network_acls = {  // 
                            description = "For test VPC, this will route all traffic between the public networks in the VPC"
                            subnet_type = "Public"  //Has to match the subnet type name on the subnet
                            ingress_obj_list = {  // 
                                ingress_rule1 = { //Allow all traffic inbound from other public networks in the Test VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.60.0.0/16" //Test public CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                            egress_obj_list = {
                                egress_rule1 = {  //Allow all traffic outbound from other public networks in the Test VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.60.0.0/16" //Test public CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                        } ,
                        Private_network_acls = {
                            description = "For test VPC, this will route all traffic between the private networks in the VPC"
                            subnet_type = "Private"  //Has to match the subnet type name on the subnet
                            ingress_obj_list = {  // 
                                ingress_rule1 = { //Allow all traffic inbound from other private networks in the Test VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.61.0.0/16" //Test private CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                            egress_obj_list = {
                                egress_rule1 = {  //Allow all traffic outbound from other private networks in the Test VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.61.0.0/16" //Test private CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                        },
                        Network_network_acls = {
                            description = "For test VPC, this will route all traffic between the network networks in the VPC"
                            subnet_type = "Network"  //Has to match the subnet type name on the subnet
                            ingress_obj_list = {  // 
                                ingress_rule1 = { //Allow all traffic inbound from other network networks in the Test VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.62.0.0/16" //Test network CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                            egress_obj_list = {
                                egress_rule1 = {  //Allow all traffic outbound from other network networks in the Test VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.62.0.0/16" //Test network CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                        } 

                    }  

                    security_groups_list_info=  {  # VPC Security groups 

                        TestVPCpublicsg1 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.0.0/24","10.51.1.0/24","10.51.2.0/24","10.51.3.0/24"]
                               // ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //ipv6_cidr_blocks = ["::/0"]
                            } 
                        },
                        TestVPCprivatesg2 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.4.0/24","10.51.5.0/24",  "10.51.6.0/24","10.51.7.0/24", "10.51.8.0/24"]
                                //ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //pv6_cidr_blocks = ["::/0"]
                            }
                        }          
                    }
					
					az_info = {

						us-east-2a = {  # Availability Zone
							//Public
							"10.60.0.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "63afdaad-0935-47fe-8106-af0231d66552"    
                            },
                            "10.60.1.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "9cd8d96d-deff-46a3-a2b4-54e34204b204"    
                            },
						    //Private
							"10.61.4.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "5fac511d-2e55-484f-a6ae-97bd2f62a764"    
                            },
                            "10.61.5.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "4719f404-49f7-4e5c-b12a-8ee1a2621f7c"    
                            },
							//Network
							"10.62.60.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "aecef4fe-286c-4c23-8eb6-0f826833fc9f"    
                            }
						},
						us-east-2b = {  # Availability Zone
							//Public 
                            "10.60.64.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "af476a0c-01ca-4f4b-8157-d0f4074cc895"    
                            },
                            "10.60.65.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "330dbf30-ea42-4963-b0fb-dbb5d9faa009"    
                            }, 
							//Private
							"10.61.68.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "721b4283-bf33-45f8-baa1-a8f4e961840c"    
                            },
                            "10.61.69.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "510ab444-a9a2-467a-a92e-87d46bec78fb"    
                            },
							//Network
							"10.62.124.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "62016bc4-7277-4706-b1cf-701cac75d42f"    
                            }
						},
						us-east-2c = {  # Availability Zone
							//Public
							"10.60.128.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "0906d355-d5c3-4f8b-af7e-13da30f1e357"    
                            },
                            "10.60.129.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "20b78587-9deb-4366-ac4e-12ac22a60696"    
                            },
							//Private
							"10.61.132.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "92a4a70d-ddbf-4f98-9add-e58773e6b1a8"    
                            },
                            "10.61.133.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "49ac3e44-a313-412e-8244-8c7e54472753"    
                            },
							//Network
							"10.62.189.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "fa6a124c-4982-40e0-8d01-a3d4f1da79b1"    
                            }
						}

					}
				},
				DevVPC = {   # VPC
					vpc_cidr_block = "10.47.0.0/16"
					vpc_environment_type = "Dev"
					vpc_enable_dns_support = true
					vpc_enable_dns_hostnames = true
                    vpc_uuid = "b5f25cb3-5785-4673-a7e7-5bfeb2994f4a"
                    default_rt_uuid = "1ad39b39-d48f-4869-930f-53a9b29d0693"
                    default_sg_uuid = "360204d5-9c09-402c-b7ff-b8238e8c3562"
                    default_netacl_uuid = "39bdfe8d-1569-4e0a-913c-4bef32a9049a"
					/*vpc_instance_tenancy = "default"
					vpc_enable_classiclink_dns_support = false
					vpc_assign_generated_ipv6_cidr_block = false
					vpc_enable_classiclink = false */


                    vpc_cidr_block_list_info = { //Additional VPC CIDRs
                        publicCIDR = {
                            cidr = "10.63.0.0/16"
                            info = "public"
                        },
                        privateCIDR = {
                            cidr = "10.64.0.0/16"
                            info = "private"
                        },
                        networkCIDR = {
                            cidr = "10.65.0.0/16"
                            info = "network"
                        }                     
                    }   
                    network_acls_list_info = {  // These are the network acls for the VPC
                        Public_network_acls = {  // 
                            description = "For Dev VPC, this will route all traffic between the public networks in the VPC"
                            subnet_type = "Public"  //Has to match the subnet type name on the subnet
                            ingress_obj_list = {  // 
                                ingress_rule1 = { //Allow all traffic inbound from other public networks in the Dev VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.63.0.0/16" //Dev public CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                            egress_obj_list = {
                                egress_rule1 = {  //Allow all traffic outbound from other public networks in the Dev VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.63.0.0/16" //Dev public CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                        } ,
                        Private_network_acls = {
                            description = "For Dev VPC, this will route all traffic between the private networks in the VPC"
                            subnet_type = "Private"  //Has to match the subnet type name on the subnet
                            ingress_obj_list = {  // 
                                ingress_rule1 = { //Allow all traffic inbound from other private networks in the Dev VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.64.0.0/16" //Dev private CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                            egress_obj_list = {
                                egress_rule1 = {  //Allow all traffic outbound from other private networks in the Dev VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.64.0.0/16" //Dev private CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                        },
                        Network_network_acls = {
                            description = "For test VPC, this will route all traffic between the network networks in the VPC"
                            subnet_type = "Network"  //Has to match the subnet type name on the subnet
                            ingress_obj_list = {  // 
                                ingress_rule1 = { //Allow all traffic inbound from other network networks in the Dev VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.65.0.0/16" //Dev network CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                            egress_obj_list = {
                                egress_rule1 = {  //Allow all traffic outbound from other network networks in the Dev VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.65.0.0/16" //Dev network CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                        } 

                    }                       

                    security_groups_list_info=  {  # VPC Security groups 

                        DevVPCpublicsg1 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.0.0/24","10.51.1.0/24","10.51.2.0/24","10.51.3.0/24"]
                               // ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //ipv6_cidr_blocks = ["::/0"]
                            } 
                        },
                        DevVPCprivatesg2 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.4.0/24","10.51.5.0/24",  "10.51.6.0/24","10.51.7.0/24", "10.51.8.0/24"]
                                //ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //pv6_cidr_blocks = ["::/0"]
                            }
                        }
                            
                    }
					
					az_info = {

						us-east-2a = {   # Availability Zone
							//Public
							"10.63.0.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "32498037-ba71-44ef-b570-abc70a4d3049"    
                            },
                            "10.63.1.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "54e6760e-9436-46c7-a025-cd0809f12279"    
                            },
							//Private
							"10.64.4.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "c419b01d-8732-427d-bf0f-85cca404e78d"    
                            },
							//Network
							"10.65.60.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "f58e992e-584a-44a4-9746-d2a596529865"    
                            }
						},
						us-east-2b = {   # Availability Zone
							//Public
							"10.63.64.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "300a8dfc-82f4-4f4e-b2fa-0ae0c34caa64"    
                            },
                            "10.63.65.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "daee1052-0e86-4010-b3c5-2fb7d2cd7d0d"    
                            },
							//Private
							"10.64.68.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "0ec869ae-fe9c-4184-9c1c-8d2e95e804a3"    
                            },
                            "10.64.69.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "b05c0305-6499-4fb9-8187-ab62a0671718"    
                            },
							//Network
							"10.65.124.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "72ca16f8-5abb-4909-95d1-ac97a6450fc0"    
                            }
						},
						us-east-2c = {  # Availability Zone
							//Public
							"10.63.128.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "e66f977f-2a16-43d1-94b9-337d9fac5350"    
                            },
							//Private
							"10.64.132.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "9fa6e498-ca39-4d91-91b8-de413892fcc2"    
                            },
							//Network
							"10.65.189.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "2d47e234-2b69-4677-8ce0-dd9bbcbe3728"    
                            }
						}
					}
				},

                SharedServiceVPC = {   # VPC
					vpc_cidr_block = "10.48.0.0/16"
					vpc_environment_type = "Prod"
					vpc_enable_dns_support = true
					vpc_enable_dns_hostnames = true
                    vpc_uuid = "8d17ad35-ad3c-43aa-86b4-fee6dfc224fd"
                    default_rt_uuid = "80e5fca2-72e5-453f-abca-be8d5ec305a4"
                    default_sg_uuid = "11ba83d0-925f-4437-8a1b-79afa6485281"
                    default_netacl_uuid = "4dae3f26-8b5f-48de-acbf-872763ca6d55"
					/*vpc_instance_tenancy = "default"
					vpc_enable_classiclink_dns_support = false
					vpc_assign_generated_ipv6_cidr_block = false
					vpc_enable_classiclink = false */

                    vpc_cidr_block_list_info = { //Additional VPC CIDRs
                        publicCIDR = {
                            cidr = "10.66.0.0/16"
                            info = "public"
                        },
                        privateCIDR = {
                            cidr = "10.67.0.0/16"
                            info = "private"
                        },
                        networkCIDR = {
                            cidr = "10.68.0.0/16"
                            info = "network"
                        }                     
                    }     
                    network_acls_list_info = {  // These are the network acls for the VPC
                        Public_network_acls = {  // 
                            description = "For SharedService VPC, this will route all traffic between the public networks in the VPC"
                            subnet_type = "Public"  //Has to match the subnet type name on the subnet
                            ingress_obj_list = {  // 
                                ingress_rule1 = { //Allow all traffic inbound from other public networks in the SharedService VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.66.0.0/16" //SharedService public CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                            egress_obj_list = {
                                egress_rule1 = {  //Allow all traffic outbound from other public networks in the SharedService VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.66.0.0/16" //SharedService public CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                        } ,
                        Private_network_acls = {
                            description = "For SharedService VPC, this will route all traffic between the private networks in the VPC"
                            subnet_type = "Private"  //Has to match the subnet type name on the subnet
                            ingress_obj_list = {  // 
                                ingress_rule1 = { //Allow all traffic inbound from other private networks in the Dev VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.67.0.0/16" //SharedService private CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                            egress_obj_list = {
                                egress_rule1 = {  //Allow all traffic outbound from other private networks in the SharedService VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.67.0.0/16" //SharedService private CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                        },
                        Network_network_acls = {
                            description = "For test VPC, this will route all traffic between the network networks in the VPC"
                            subnet_type = "Network"  //Has to match the subnet type name on the subnet
                            ingress_obj_list = {  // 
                                ingress_rule1 = { //Allow all traffic inbound from other network networks in the SharedService VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.68.0.0/16" //SharedService network CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                            egress_obj_list = {
                                egress_rule1 = {  //Allow all traffic outbound from other network networks in the SharedService VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.68.0.0/16" //SharedService network CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                        } 

                    }                      

                    security_groups_list_info=  {  # VPC Security groups 

                        SharedServiceVPCpublicsg1 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.0.0/24","10.51.1.0/24","10.51.2.0/24","10.51.3.0/24"]
                               // ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //ipv6_cidr_blocks = ["::/0"]
                            } 
                        },
                        SharedServiceVPCprivatesg2 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.4.0/24","10.51.5.0/24",  "10.51.6.0/24","10.51.7.0/24", "10.51.8.0/24"]
                                //ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //pv6_cidr_blocks = ["::/0"]
                            }
                        }
                            
                    }
					
					az_info = {

						us-east-2a = {   # Availability Zone
							//Public
							"10.66.0.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "156d6773-ea3b-4344-9ac2-c0999d976f7a"    
                            },
							//Private
							"10.67.4.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "60246d6c-86e0-485f-a5db-76c13756cbd9"    
                            },
							//Network
							"10.68.60.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "efdbc5ff-b8cb-4766-b9cb-701ac5c21778"    
                            }
						},
						us-east-2b = {   # Availability Zone
							//Public
							"10.66.6.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "9c15719c-f07c-40de-94fe-4addba83c692"    
                            },
							//Private
							"10.67.68.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "599fc341-a2d3-45ed-b555-2411d1bec14b"    
                            },
							//Network 
							"10.68.124.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "786ed620-75b7-4767-bc41-2f43eb553948"    
                            }
						},
						us-east-2c = {  # Availability Zone
							//Public
							"10.66.128.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "f75860a7-23d2-4c0b-9600-7f910d762dde"    
                            },
							//Private
							"10.67.132.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "7650511e-549e-4a7e-ada7-116e330244c9"    
                            },
							//Network
							"10.68.189.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "7a6a1654-71d9-44f5-98da-9a5aa7e3ab2b"    
                            }
						}

					}
				},
                SandBoxVPC = {   # VPC
					vpc_cidr_block = "10.49.0.0/16"
					vpc_environment_type = "Dev"
					vpc_enable_dns_support = true
					vpc_enable_dns_hostnames = true
                    vpc_uuid = "b9c2e117-472b-429d-a767-3c23e0dea689"
                    default_rt_uuid = "fc34688b-189c-4949-86dc-0fde7f00ae36"
                    default_sg_uuid = "c09f12e5-0b35-465f-80bc-705f7c11e878"
                    default_netacl_uuid = "d7246aeb-fece-448e-aa19-fb4b4a94f43e"
					/*vpc_instance_tenancy = "default"
					vpc_enable_classiclink_dns_support = false
					vpc_assign_generated_ipv6_cidr_block = false
					vpc_enable_classiclink = false */

                    vpc_cidr_block_list_info = { //Additional VPC CIDRs
                        publicCIDR = {
                            cidr = "10.69.0.0/16"
                            info = "public"
                        },
                        privateCIDR = {
                            cidr = "10.70.0.0/16"
                            info = "private"
                        },
                        networkCIDR = {
                            cidr = "10.71.0.0/16"
                            info = "network"
                        }                     
                    }     
                    network_acls_list_info = {  // These are the network acls for the VPC
                        Public_network_acls = {  // 
                            description = "For SharedService VPC, this will route all traffic between the public networks in the VPC"
                            subnet_type = "Public"  //Has to match the subnet type name on the subnet
                            ingress_obj_list = {  // 
                                ingress_rule1 = { //Allow all traffic inbound from other public networks in the SharedService VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.69.0.0/16" //SharedService public CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                            egress_obj_list = {
                                egress_rule1 = {  //Allow all traffic outbound from other public networks in the SharedService VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.69.0.0/16" //SharedService public CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                        } ,
                        Private_network_acls = {
                            description = "For SharedService VPC, this will route all traffic between the private networks in the VPC"
                            subnet_type = "Private"  //Has to match the subnet type name on the subnet
                            ingress_obj_list = {  // 
                                ingress_rule1 = { //Allow all traffic inbound from other private networks in the Dev VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.70.0.0/16" //SharedService private CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                            egress_obj_list = {
                                egress_rule1 = {  //Allow all traffic outbound from other private networks in the SharedService VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.70.0.0/16" //SharedService private CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                        },
                        Network_network_acls = {
                            description = "For test VPC, this will route all traffic between the network networks in the VPC"
                            subnet_type = "Network"  //Has to match the subnet type name on the subnet
                            ingress_obj_list = {  // 
                                ingress_rule1 = { //Allow all traffic inbound from other network networks in the SharedService VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.71.0.0/16" //SharedService network CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                            egress_obj_list = {
                                egress_rule1 = {  //Allow all traffic outbound from other network networks in the SharedService VPC
                                protocol   = "-1"
                                rule_no    = 100
                                action     = "allow"
                                cidr_block = "10.71.0.0/16" //SharedService network CIDR
                                from_port  = 0
                                to_port    = 0
                                }
                            }
                        } 

                    }                        

                    security_groups_list_info=  {  # VPC Security groups 

                        SandBoxVPCpublicsg1 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.0.0/24","10.51.1.0/24","10.51.2.0/24","10.51.3.0/24"]
                               // ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //ipv6_cidr_blocks = ["::/0"]
                            } 
                        },
                        SandBoxVPCprivatesg2 = {
                            description = "Allow TLS inbound traffic"
                            ingress = {
                                description      = "TLS from VPC"
                                from_port        = 443
                                to_port          = 443
                                protocol         = "tcp"
                                cidr_blocks      = ["10.51.4.0/24","10.51.5.0/24",  "10.51.6.0/24","10.51.7.0/24", "10.51.8.0/24"]
                                //ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
                            }   
                            egress = {
                                from_port        = 0
                                to_port          = 0
                                protocol         = "-1"
                                cidr_blocks      = ["0.0.0.0/0"]
                                //pv6_cidr_blocks = ["::/0"]
                            }
                        }                           
                    }
					
					az_info = {

						us-east-2a = {   # Availability Zone
							//Public
							"10.69.0.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "86cda81e-3f42-4f1e-8723-283b95c7fd75"    
                            },
                            "10.69.1.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "3911c81e-9afa-431a-93ab-5297027da1b5"    
                            },
							//Private
							"10.70.4.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "2f973602-d746-4df7-b22d-0bf4af8a76ab"    
                            },
							//Network
							"10.71.60.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "65a7f1fe-5731-43ae-bf27-5506160ab3aa"    
                            }
						},
						us-east-2b = {   # Availability Zone
							//Public 
                            "10.69.64.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "66090c75-9dc8-489c-8f1f-b9ef97b40be1"    
                            },
							//Private
							"10.70.68.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "b3d6cb52-9394-4ea8-a8f6-8d59f082efe0"    
                            },
                            "10.70.69.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "a0576367-2b6c-43d0-bc63-6428b7390762"    
                            },
							//Network
							"10.71.124.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "cb9dc12c-1e73-4590-8751-98640835a1f5"    
                            }
						},
						us-east-2c = {  # Availability Zone
							//Public
							"10.69.128.0/24" = {
                                sn_class_type = "Public"
                                sn_uuid = "055ebc2b-4760-426f-bde9-67d8a3de6232"    
                            },
							//Private
							"10.70.132.0/24" = {
                                sn_class_type = "Private"
                                sn_uuid = "b71b8198-bc70-4c77-acba-65c34c17bcc0"    
                            },
							//Network
							"10.71.189.0/24" = {
                                sn_class_type = "Network"
                                sn_uuid = "253b4fe1-acdf-40e4-9436-ffef733adacf"    
                            }
						}
					}
				}
			}
		}
    }

}

