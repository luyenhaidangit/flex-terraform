########################################
# Public Route Table
########################################

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = {
    Name = "${var.name}-public-rt"
    Tier = "public"
  }
}

########################################
# Route Table Association
########################################

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = var.subnet_id
}
