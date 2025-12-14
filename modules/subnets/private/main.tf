########################################
# VPC
########################################

resource "aws_vpc" "this" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name}-subnet"
  }
}
