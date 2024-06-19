resource "aws_vpc" "primary_aws_backend_vpc" {
  cidr_block       = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name        = "primary-${var.prefix_name}-vpc"
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_subnet" "primary_aws_backend_private_subnet1" {
  vpc_id            = aws_vpc.primary_aws_backend_vpc.id
  cidr_block        = var.private_subnet1_cidr_block
  availability_zone = var.private_subnet1_az
  map_public_ip_on_launch = false

  tags = {
    Name        = "primary-${var.prefix_name}-private-subnet-1"
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_subnet" "primary_aws_backend_private_subnet2" {
  vpc_id            = aws_vpc.primary_aws_backend_vpc.id
  cidr_block        = var.private_subnet2_cidr_block
  availability_zone = var.private_subnet2_az
  map_public_ip_on_launch = false

  tags = {
    Name        = "primary-${var.prefix_name}-private-subnet-2"
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_subnet" "primary_aws_backend_public_subnet1" {
  vpc_id            = aws_vpc.primary_aws_backend_vpc.id
  cidr_block        = var.public_subnet1_cidr_block
  availability_zone = var.public_subnet1_az
  map_public_ip_on_launch = false

  tags = {
    Name        = "primary-${var.prefix_name}-public-subnet-1"
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_subnet" "primary_aws_backend_public_subnet2" {
  vpc_id            = aws_vpc.primary_aws_backend_vpc.id
  cidr_block        = var.public_subnet2_cidr_block
  availability_zone = var.public_subnet2_az
  map_public_ip_on_launch = false

  tags = {
    Name        = "primary-${var.prefix_name}-public-subnet-2"
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_security_group" "primary_aws_backend_security_group1" {
  name        = "primary-${var.prefix_name}-sg-1"
  description = "Enable access to ALB"
  vpc_id      = aws_vpc.primary_aws_backend_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  
  # Existing egress rules remain unchanged
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "primary_aws_backend_security_group2" {
  name        = "primary-${var.prefix_name}-sg-2"
  description = "Enable access to Lambda"
  vpc_id      = aws_vpc.primary_aws_backend_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_security_group" "primary_aws_backend_security_group3" {
  name        = "primary-${var.prefix_name}-sg-3"
  description = "Enable access to API Gateway"
  vpc_id      = aws_vpc.primary_aws_backend_vpc.id

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

resource "aws_security_group" "primary_aws_backend_security_group4" {
  name        = "primary-${var.prefix_name}-sg-4"
  description = "Enable access to NLB"
  vpc_id      = aws_vpc.primary_aws_backend_vpc.id

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

##### creation of custom route tables

resource "aws_route_table" "primary_aws_backend_private_route_table" {
  vpc_id = aws_vpc.primary_aws_backend_vpc.id

  tags = {
    Name = "primary-${var.prefix_name}-private-route-table"
  }
}

resource "aws_route_table" "primary_aws_backend_public_route_table" {
  vpc_id = aws_vpc.primary_aws_backend_vpc.id

  tags = {
    Name = "primary-${var.prefix_name}-public-route-table"
  }
}

##### associate private subnets to private route table

resource "aws_route_table_association" "primary_aws_backend_private_subnet1_association" {
  subnet_id      = aws_subnet.primary_aws_backend_private_subnet1.id
  route_table_id = aws_route_table.primary_aws_backend_private_route_table.id
}

resource "aws_route_table_association" "primary_aws_backend_private_subnet2_association" {
  subnet_id      = aws_subnet.primary_aws_backend_private_subnet2.id
  route_table_id = aws_route_table.primary_aws_backend_private_route_table.id
}

##### associate public subnets to public route table

resource "aws_route_table_association" "primary_aws_backend_public_subnet1_association" {
  subnet_id      = aws_subnet.primary_aws_backend_public_subnet1.id
  route_table_id = aws_route_table.primary_aws_backend_public_route_table.id
}

resource "aws_route_table_association" "primary_aws_backend_public_subnet2_association" {
  subnet_id      = aws_subnet.primary_aws_backend_public_subnet2.id
  route_table_id = aws_route_table.primary_aws_backend_public_route_table.id
}

##### internet gateways

resource "aws_internet_gateway" "primary_aws_backend_internet_gateway" {
  vpc_id = aws_vpc.primary_aws_backend_vpc.id

  tags = {
    Name = "primary-${var.prefix_name}-internet-gateway"
  }
}

# add internet gateway to public route table

resource "aws_route" "primary_aws_backend_ig_route1" {
  route_table_id         = aws_route_table.primary_aws_backend_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.primary_aws_backend_internet_gateway.id
}

# create multiple of this if there are mongoDBs deployed in different VPCs
resource "aws_vpc_endpoint" "primary_aws_backend_vpc_endpoint" {
  vpc_id              = aws_vpc.primary_aws_backend_vpc.id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.aws_region}.execute-api"
  private_dns_enabled = true
  subnet_ids = [
    aws_subnet.primary_aws_backend_private_subnet1.id,
    aws_subnet.primary_aws_backend_private_subnet2.id
  ]
  security_group_ids = [
    aws_security_group.primary_aws_backend_security_group3.id
  ]
  tags = {
    Name = "primary-${var.prefix_name}-api-vpce"
  }
}

##### nat gateway

resource "aws_nat_gateway" "primary_aws_backend_nat_gateway" {
  allocation_id = aws_eip.primary_aws_backend_nat_eip.id
  subnet_id     = aws_subnet.primary_aws_backend_public_subnet1.id

  tags = {
    Name = "primary-${var.prefix_name}-nat-gateway"
  }
}

resource "aws_eip" "primary_aws_backend_nat_eip" {
  vpc = true
}

# add nat gateways to private route table

resource "aws_route" "primary_aws_backend_ng_route" {
  route_table_id         = aws_route_table.primary_aws_backend_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.primary_aws_backend_nat_gateway.id
}

##### vpc peering with a different aws account

resource "aws_vpc_peering_connection" "primary_aws_backend_peering_connection" {
  vpc_id      = aws_vpc.primary_aws_backend_vpc.id
  peer_vpc_id   = var.peer_vpc_id
  peer_owner_id = var.peer_aws_account_id
  auto_accept   = false

  tags = {
    Name = "primary-${var.prefix_name}-vpc-peering"
  }
}

resource "aws_route" "primary_aws_backend_route" {
  route_table_id            = aws_route_table.primary_aws_backend_private_route_table.id
  destination_cidr_block    = var.peer_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_aws_backend_peering_connection.id
}