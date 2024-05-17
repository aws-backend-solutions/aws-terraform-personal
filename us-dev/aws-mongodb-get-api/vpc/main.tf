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