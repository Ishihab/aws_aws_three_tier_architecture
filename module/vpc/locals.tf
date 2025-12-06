
locals {
    number_of_azs = var.number_of_azs > length(data.aws_availability_zones.available_zones.names) ? length(data.aws_availability_zones.available_zones.names) : var.number_of_azs
    azs = slice(data.aws_availability_zones.available_zones.names, 0, local.number_of_azs) 
}

locals {
    subnets = merge([
        for az_index, az in local.azs : {
            for subnet_type, type_index in var.subnet_types :
            "${az}-${subnet_type}" => {
                az          = az
                subnet_type = subnet_type
                az_name = az
                cidr_index = az_index * 4 + type_index
            }
        }   
    ]...)
}

locals {
  # Filter private subnets (app or db type)
  private_subnets = {
    for key, subnet in local.subnets : key => subnet
    if contains(["app", "db"], subnet.subnet_type)
  }
  
  # Select the first private subnet
  private_subnet_for_eic = keys(local.private_subnets)[0]
}
