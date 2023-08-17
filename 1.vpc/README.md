 
# Migration Path
    7.9.1 <-8.6.1.40680 LTS <- 6.7.5.38563 (Old version)
    
# Map List and Objects
    list (or tuple): a sequence of values, like ["us-west-1a", "us-west-1c"]. Elements in a list or tuple are identified by consecutive whole numbers, starting with zero.

    map (or object): a group of values identified by named labels, like {name = "Mabel", age = 52}.


    terraform init to get the necessary modules AWS and Null
    terraform apply to create resources



 ../../../terraform1.5.3/terraform plan -var-file="../sharedvariables/terraform.tfvars"
