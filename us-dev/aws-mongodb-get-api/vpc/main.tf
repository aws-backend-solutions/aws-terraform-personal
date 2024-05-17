resource "aws_vpc_peering_connection" "aws_mongodb_ga_peering_connection" {
  vpc_id      = var.aws_backend_vpc_id
  peer_vpc_id = var.vpc_id_to_peer

  tags = {
    Name = "${var.prefix_name}-vpc-peering"
  }
}

resource "aws_route" "aws_mongodb_ga_route" {
  route_table_id            = var.aws_backend_private_route_table_id
  destination_cidr_block    = var.cidr_block_of_vpc_to_peer
  vpc_peering_connection_id = aws_vpc_peering_connection.aws_mongodb_ga_peering_connection.id
}

resource "aws_vpc_endpoint" "aws_backend_vpc_endpoint" {
  vpc_id              = var.aws_backend_vpc_id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.aws_region}.execute-api"
  private_dns_enabled = true
  subnet_ids = [
    var.aws_backend_private_subnet1_id,
    var.aws_backend_private_subnet2_id
  ]
  security_group_ids = [
    var.aws_backend_security_group3_id
  ]
  tags = {
    Name = "${var.prefix_name}-api-vpce"
  }
}