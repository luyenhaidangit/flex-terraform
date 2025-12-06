########################################
# 1. Public subnets
########################################

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-public-${var.az}"
      Tier = "public"
    }
  )
}

########################################
# 2. Private subnets
########################################

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-private-${var.az}"
      Tier = "app"
    }
  )
}

########################################
# 3. DB subnets
########################################

resource "aws_subnet" "db" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.db_subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-db-${var.az}"
      Tier = "db"
    }
  )
}