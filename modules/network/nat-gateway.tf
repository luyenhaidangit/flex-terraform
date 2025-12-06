########################################
# 4. NAT Gateway (1 per AZ — best practice)
########################################

/*
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = merge(
    var.tags,
    { Name = "${var.name}-nat-eip-${var.az}" }
  )
}
*/

/*
resource "aws_nat_gateway" "nat" {
  for_each = aws_subnet.public

  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = merge(
    var.tags,
    { Name = "${var.name}-nat" }
  )
}
*/