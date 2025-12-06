resource "aws_subnet" "subnets" {
    for_each = local.subnets

    vpc_id            = aws_vpc.vpc.id
    cidr_block        = cidrsubnet(var.cidr_block, 4, each.value.cidr_index)
    ipv6_cidr_block = cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, each.value.cidr_index)
    availability_zone = each.value.az_name
    map_public_ip_on_launch = each.value.subnet_type == "web" ? true : false
    assign_ipv6_address_on_creation = true
    tags = {
        Name = "subnet-${each.value.az_name}-${each.value.subnet_type}"
    }
  
}

resource "aws_db_subnet_group" "db_subnet_group" {
    name       = "db-subnet-group"
    subnet_ids = [
      for subnet_key, subnet in local.subnets : aws_subnet.subnets[subnet_key].id
      if subnet.subnet_type == "db"
    ]
    tags = {
        Name = "db-subnet-group"
    }
  
}