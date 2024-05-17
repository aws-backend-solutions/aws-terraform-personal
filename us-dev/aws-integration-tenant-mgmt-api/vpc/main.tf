resource "aws_nat_gateway" "aws_integration_tenant_mgmt_nat_gateway" {
  allocation_id = aws_eip.aws_integration_tenant_mgmt_nat_eip.id
  subnet_id     = var.aws_backend_public_subnet1_id

  tags = {
    Name = "${var.prefix_name}-nat-gateway"
  }
}

resource "aws_eip" "aws_integration_tenant_mgmt_nat_eip" {
  vpc = true
}

# add nat gateways to private route table

resource "aws_route" "aws_backend_ng_route" {
  route_table_id         = var.aws_backend_private_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.aws_integration_tenant_mgmt_nat_gateway.id
}