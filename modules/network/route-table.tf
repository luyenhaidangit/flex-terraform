########################################
# 5. Route Tables
########################################

#-----------------------------------------
# 5.1 Public Route Table → IGW (shared)
#-----------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-public-rt"
      Tier = "public"
    }
  )
}

resource "aws_route_table_association" "public" {
  count = length(var.azs)

  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

#-----------------------------------------
# 5.2 Private Route Tables → NAT Gateway
#-----------------------------------------
resource "aws_route_table" "private" {
  count = length(var.azs)

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-private-rt-${var.azs[count.index]}"
      Tier = "private"
    }
  )
}

# Route to NAT Gateway (if enabled)
resource "aws_route" "private_nat" {
  count = var.enable_nat_gateway ? length(var.azs) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  # If single NAT, all private subnets use NAT[0]; otherwise use NAT per AZ
  nat_gateway_id = var.single_nat_gateway ? aws_nat_gateway.this[0].id : aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "private" {
  count = length(var.azs)

  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = aws_subnet.private[count.index].id
}

#-----------------------------------------
# 5.3 DB Route Table – isolated (no Internet)
#-----------------------------------------
resource "aws_route_table" "db" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-db-rt"
      Tier = "db"
    }
  )
}

resource "aws_route_table_association" "db" {
  count = length(var.azs)

  route_table_id = aws_route_table.db.id
  subnet_id      = aws_subnet.db[count.index].id
}