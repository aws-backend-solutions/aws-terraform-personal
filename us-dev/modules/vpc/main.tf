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
    aws_subnet.aws_backend_public_subnet1.id, 
    aws_subnet.aws_backend_public_subnet2.id
  ]
  security_group_ids  = [
    aws_security_group.aws_backend_security_group1.id
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

resource "aws_route_table" "aws_backend_public_route_table1" {
  vpc_id = aws_vpc.aws_backend_vpc.id

  tags = {
    Name = "aws-backend-public-route-table-1"
  }
}

resource "aws_route_table" "aws_backend_public_route_table2" {
  vpc_id = aws_vpc.aws_backend_vpc.id

  tags = {
    Name = "aws-backend-public-route-table-2"
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
  route_table_id = aws_route_table.aws_backend_public_route_table1.id
}

resource "aws_route_table_association" "aws_backend_public_subnet2_association" {
  subnet_id      = aws_subnet.aws_backend_public_subnet2.id
  route_table_id = aws_route_table.aws_backend_public_route_table2.id
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

resource "aws_internet_gateway" "aws_backend_internet_gateway1" {
  vpc_id = aws_vpc.aws_backend_vpc.id

  tags = {
    Name = "aws-backend-internet-gateway-1"
  }
}

resource "aws_internet_gateway" "aws_backend_internet_gateway2" {
  vpc_id = aws_vpc.aws_backend_vpc.id

  tags = {
    Name = "aws-backend-internet-gateway-2"
  }
}

# add internet gateway to public route table

resource "aws_route" "aws_backend_ig_route1" {
  route_table_id         = aws_route_table.aws_backend_public_route_table1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws_backend_internet_gateway1.id
}

resource "aws_route" "aws_backend_ig_route2" {
  route_table_id         = aws_route_table.aws_backend_public_route_table2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws_backend_internet_gateway2.id
}

##### nat gateways
# add nat gateways to public subnets

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

resource "aws_eip" "aws_backend_nat_eip1" {
  vpc = true
}

resource "aws_eip" "aws_backend_nat_eip2" {
  vpc = true
}

# add nat gateways to private route table

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