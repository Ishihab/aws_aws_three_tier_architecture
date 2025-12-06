resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "igw"
    }
}


resource "aws_eip" "nat_eip" {
    for_each = {
      for subnet_key, subnet in local.subnets : subnet_key => subnet 
      if subnet.subnet_type == "web"
    }

    tags = {
        Name = "nat-eip-${each.value.az_name}"
    }

    depends_on = [ aws_internet_gateway.igw ]
  
}

resource "aws_nat_gateway" "nat_gw" {
    for_each = {
      for subnet_key, subnet in local.subnets : subnet_key => subnet 
      if subnet.subnet_type == "web"
    }

    allocation_id = aws_eip.nat_eip[each.key].id
    subnet_id     = aws_subnet.subnets[each.key].id
    tags = {
        Name = "nat-gw-${each.value.az_name}"
    }
  
}


