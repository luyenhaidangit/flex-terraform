########################################
# 4. NAT Gateway
########################################

locals {
  # If single_nat_gateway = true, create 1 NAT; otherwise create 1 per AZ
  nat_gateway_count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.azs)) : 0
}

resource "aws_eip" "nat" {
  count  = local.nat_gateway_count
  domain = "vpc"

  tags = merge(
    var.tags,
    { Name = "${var.name}-nat-eip-${var.azs[count.index]}" }
  )

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "this" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.tags,
    { Name = "${var.name}-nat-${var.azs[count.index]}" }
  )

  depends_on = [aws_internet_gateway.igw]
}