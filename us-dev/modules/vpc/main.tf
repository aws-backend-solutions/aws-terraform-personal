resource "aws_vpc" "aws_backend_vpc" {
  cidr_block       = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name        = "aws-backend-vpc"
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_subnet" "aws_backend_private_subnet1" {
  vpc_id            = aws_vpc.aws_backend_vpc.id
  cidr_block        = var.private_subnet1_cidr_block
  availability_zone = var.private_subnet1_az
  map_public_ip_on_launch = false

  tags = {
    Name        = "aws-backend-private-subnet-1"
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_subnet" "aws_backend_private_subnet2" {
  vpc_id            = aws_vpc.aws_backend_vpc.id
  cidr_block        = var.private_subnet2_cidr_block
  availability_zone = var.private_subnet2_az
  map_public_ip_on_launch = false

  tags = {
    Name        = "aws-backend-private-subnet-2"
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_subnet" "aws_backend_public_subnet1" {
  vpc_id            = aws_vpc.aws_backend_vpc.id
  cidr_block        = var.public_subnet1_cidr_block
  availability_zone = var.public_subnet1_az
  map_public_ip_on_launch = false

  tags = {
    Name        = "aws-backend-public-subnet-1"
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_subnet" "aws_backend_public_subnet2" {
  vpc_id            = aws_vpc.aws_backend_vpc.id
  cidr_block        = var.public_subnet2_cidr_block
  availability_zone = var.public_subnet2_az
  map_public_ip_on_launch = false

  tags = {
    Name        = "aws-backend-public-subnet-2"
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_security_group" "aws_backend_security_group1" {
  name        = "aws-backend-sg-1"
  description = "Enable access to ALB"
  vpc_id      = aws_vpc.aws_backend_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22   # SSH port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust this CIDR block to match your network's IP range
  }

  ingress {
    from_port   = 3389   # RDP port
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust this CIDR block to match your network's IP range
  }

  ingress {
    from_port   = -1   # ICMP (ping)
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust this CIDR block to match your network's IP range
  }
  
  # Existing egress rules remain unchanged
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "aws_backend_security_group2" {
  name        = "aws-backend-sg-2"
  description = "Enable access to Lambda"
  vpc_id      = aws_vpc.aws_backend_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "aws_backend_vpc_endpoint" {
  vpc_id              = aws_vpc.aws_backend_vpc.id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.aws_region}.execute-api"
  private_dns_enabled = true
  subnet_ids          = [
    aws_subnet.aws_backend_private_subnet1.id, 
    aws_subnet.aws_backend_private_subnet2.id
  ]
  security_group_ids  = [
    aws_security_group.aws_backend_security_group2.id
  ]
}

##### creation of custom route tables

resource "aws_route_table" "aws_backend_private_route_table1" {
  vpc_id = aws_vpc.aws_backend_vpc.id

  tags = {
    Name = "aws-backend-private-route-table-1"
  }
}

resource "aws_route_table" "aws_backend_private_route_table2" {
  vpc_id = aws_vpc.aws_backend_vpc.id

  tags = {
    Name = "aws-backend-private-route-table-2"
  }
}

resource "aws_route_table" "aws_backend_public_route_table" {
  vpc_id = aws_vpc.aws_backend_vpc.id

  tags = {
    Name = "aws-backend-public-route-table"
  }
}

##### associate private subnets to private route table

resource "aws_route_table_association" "aws_backend_private_subnet1_association" {
  subnet_id      = aws_subnet.aws_backend_private_subnet1.id
  route_table_id = aws_route_table.aws_backend_private_route_table1.id
}

resource "aws_route_table_association" "aws_backend_private_subnet2_association" {
  subnet_id      = aws_subnet.aws_backend_private_subnet2.id
  route_table_id = aws_route_table.aws_backend_private_route_table2.id
}

##### associate public subnets to public route table

resource "aws_route_table_association" "aws_backend_public_subnet1_association" {
  subnet_id      = aws_subnet.aws_backend_public_subnet1.id
  route_table_id = aws_route_table.aws_backend_public_route_table.id
}

resource "aws_route_table_association" "aws_backend_public_subnet2_association" {
  subnet_id      = aws_subnet.aws_backend_public_subnet2.id
  route_table_id = aws_route_table.aws_backend_public_route_table.id
}

##### vpc peering

resource "aws_vpc_peering_connection" "aws_backend_vpc_peering_connection" {
  vpc_id        = aws_vpc.aws_backend_vpc.id
  peer_vpc_id   = var.vpc_id_to_peer

  tags = {
    Name = "aws-backend-vpc-peering"
  }
}

# add vpc peering to private route table

resource "aws_route" "aws_backend_vpc_route1" {
  route_table_id              = aws_route_table.aws_backend_private_route_table1.id
  destination_cidr_block      = var.cidr_block_of_vpc_to_peer
  vpc_peering_connection_id   = aws_vpc_peering_connection.aws_backend_vpc_peering_connection.id
}

resource "aws_route" "aws_backend_vpc_route2" {
  route_table_id              = aws_route_table.aws_backend_private_route_table2.id
  destination_cidr_block      = var.cidr_block_of_vpc_to_peer
  vpc_peering_connection_id   = aws_vpc_peering_connection.aws_backend_vpc_peering_connection.id
}

##### internet gateways

resource "aws_internet_gateway" "aws_backend_internet_gateway" {
  vpc_id = aws_vpc.aws_backend_vpc.id

  tags = {
    Name = "aws-backend-internet-gateway"
  }
}

# add internet gateway to public route table

resource "aws_route" "aws_backend_ig_route1" {
  route_table_id         = aws_route_table.aws_backend_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws_backend_internet_gateway.id
}

##### NAT gateways

resource "aws_eip" "aws_backend_nat_eip1" {
  vpc = true
}

resource "aws_eip" "aws_backend_nat_eip2" {
  vpc = true
}

# add NAT gateways to public subnets

resource "aws_nat_gateway" "aws_backend_nat_gateway1" {
  allocation_id = aws_eip.aws_backend_nat_eip1.id
  subnet_id     = aws_subnet.aws_backend_public_subnet1.id

  tags = {
    Name = "aws-backend-nat-gateway-1"
  }
}

resource "aws_nat_gateway" "aws_backend_nat_gateway2" {
  allocation_id = aws_eip.aws_backend_nat_eip2.id
  subnet_id     = aws_subnet.aws_backend_public_subnet2.id

  tags = {
    Name = "aws-backend-nat-gateway-2"
  }
}

# add NAT gateways to private route table

resource "aws_route" "aws_backend_ng_route1" {
  route_table_id         = aws_route_table.aws_backend_private_route_table1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.aws_backend_nat_gateway1.id
}

resource "aws_route" "aws_backend_ng_route2" {
  route_table_id         = aws_route_table.aws_backend_private_route_table2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.aws_backend_nat_gateway2.id
}

##### adding vpn connection into vpc

resource "aws_customer_gateway" "aws_backend_customer_gateway" {
  bgp_asn    = 65000
  ip_address = var.ip_address_of_customer
  type       = "ipsec.1"

  tags = {
    Name = "aws-backend-customer-gateway"
  }
}

resource "aws_vpn_gateway" "aws_backend_virtual_gateway" {
  vpc_id = aws_vpc.aws_backend_vpc.id

  tags = {
    Name = "aws-backend-virtual-gateway"
  }
}

resource "aws_vpn_gateway_attachment" "aws_backend_virtual_gateway_attachment" {
  depends_on = [ aws_vpn_gateway.aws_backend_virtual_gateway ]
  vpc_id       = aws_vpc.aws_backend_vpc.id
  vpn_gateway_id = aws_vpn_gateway.aws_backend_virtual_gateway.id
}

# propagated routes should be enabled manually through console

resource "aws_vpn_connection" "aws_backend_vpn_connection" {
  customer_gateway_id = aws_customer_gateway.aws_backend_customer_gateway.id
  vpn_gateway_id      = aws_vpn_gateway.aws_backend_virtual_gateway.id
  type                = "ipsec.1"

  tags = {
    Name = "aws-backend-vpn-connection"
  }
}