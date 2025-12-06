########################################
# 5. Route Tables
########################################

# Public RT → IGW
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

resource "aws_route_table_association" "public_assoc" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id
}

# Private RT → NAT per AZ
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  /*
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  */

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-private-rt"
      Tier = "private"
    }
  )
}

resource "aws_route_table_association" "private_assoc" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private.id
}

# DB subnet – isolated (không ra Internet)
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

resource "aws_route_table_association" "db_assoc" {
  route_table_id = aws_route_table.db.id
  subnet_id      = aws_subnet.db.id
}