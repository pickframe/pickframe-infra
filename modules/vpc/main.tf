resource "aws_vpc" "new-vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "subnets" {
  count = 2
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = aws_vpc.new-vpc.id
  cidr_block = "10.0.${count.index + 1}.0/24"
  #map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "new-internet-gateway" {
  vpc_id = aws_vpc.new-vpc.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_route_table" "new-route-table" {
  vpc_id = aws_vpc.new-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.new-internet-gateway.id
  }
  tags = {
    Name = "${var.prefix}-rtb"
  }
}

# # Criação da Rota Default para Acesso à Internet
# resource "aws_route" "new-route" {
#   route_table_id            = aws_route_table.new-route-table.id
#   destination_cidr_block    = "0.0.0.0/0"
#   gateway_id                = aws_internet_gateway.new-internet-gateway.id
# }

resource "aws_route_table_association" "new-rtb-association" {
  count = 2
  subnet_id = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.new-route-table.id
}