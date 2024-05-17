##### NAT gateways

resource "aws_eip" "aws_backend_nat_eip1" {
  vpc = true
}

# add NAT gateways to public subnets

resource "aws_nat_gateway" "aws_backend_nat_gateway" {
  allocation_id = aws_eip.aws_backend_nat_eip1.id
  subnet_id     = aws_subnet.aws_backend_public_subnet1.id

  tags = {
    Name = "${var.prefix_name}-nat-gateway"
  }
}

# add NAT gateways to private route table

resource "aws_route" "aws_backend_ng_route" {
  route_table_id         = aws_route_table.aws_backend_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.aws_backend_nat_gateway.id
}