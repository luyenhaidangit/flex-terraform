########################################
# Private Route Table
########################################

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = {
    Name = "${var.name}-private-rt"
    Tier = "private"
  }
}

########################################
# Route Table Association
########################################

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id
  subnet_id      = var.subnet_id
}
