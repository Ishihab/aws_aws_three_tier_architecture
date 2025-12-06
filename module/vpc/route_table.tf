resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "public_rt"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    route {
        ipv6_cidr_block = "::/0"
        gateway_id      = aws_internet_gateway.igw.id
    }
  
}

resource "aws_route_table_association" "public_rt_associations" {
    for_each = {
      for subnet_key, subnet in local.subnets : subnet_key => subnet 
      if subnet.subnet_type == "web"
    }

    subnet_id      = aws_subnet.subnets[each.key].id
    route_table_id = aws_route_table.public_rt.id
  
}

resource "aws_route_table" "private_rt" {
    for_each = {
      for subnet_key, subnet in local.subnets : subnet_key => subnet 
      if subnet.subnet_type == "web"
    }

    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "private-rt-${each.value.az_name}"
    }

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gw[each.key].id
    }

}


resource "aws_route_table_association" "private_rt_associations" {
    for_each = {
      for subnet_key, subnet in local.subnets : subnet_key => subnet 
      if subnet.subnet_type != "web"
    }

    subnet_id      = aws_subnet.subnets[each.key].id
    route_table_id = aws_route_table.private_rt["${each.value.az_name}-web"].id
}

