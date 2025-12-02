########################################
# 1. VPC
########################################

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    { Name = "${var.name}-vpc" }
  )
}

########################################
# 2. Internet Gateway
########################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    { Name = "${var.name}-igw" }
  )
}

########################################
# 3. Subnets (public, private, db)
########################################

resource "aws_subnet" "public" {
  for_each = {
    for idx, az in var.azs :
    idx => {
      az   = az
      cidr = var.public_subnet_cidrs[idx]
    }
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-public-${each.value.az}"
      Tier = "public"
    }
  )
}

resource "aws_subnet" "private" {
  for_each = {
    for idx, az in var.azs :
    idx => {
      az   = az
      cidr = var.private_subnet_cidrs[idx]
    }
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-private-${each.value.az}"
      Tier = "app"
    }
  )
}

resource "aws_subnet" "db" {
  for_each = {
    for idx, az in var.azs :
    idx => {
      az   = az
      cidr = var.db_subnet_cidrs[idx]
    }
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-db-${each.value.az}"
      Tier = "db"
    }
  )
}

########################################
# 4. NAT Gateway (1 per AZ — best practice)
########################################

resource "aws_eip" "nat_eip" {
  for_each = aws_subnet.public

  domain = "vpc"

  tags = merge(
    var.tags,
    { Name = "${var.name}-nat-eip-${each.value.availability_zone}" }
  )
}

resource "aws_nat_gateway" "nat" {
  for_each = aws_subnet.public

  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = each.value.id

  tags = merge(
    var.tags,
    { Name = "${var.name}-nat-${each.key}" }
  )
}

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
  for_each = aws_subnet.public

  route_table_id = aws_route_table.public.id
  subnet_id      = each.value.id
}

# Private RT → NAT per AZ
resource "aws_route_table" "private" {
  for_each = aws_subnet.private

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-private-rt-${each.key}"
      Tier = "private"
    }
  )
}

resource "aws_route_table_association" "private_assoc" {
  for_each = aws_subnet.private

  route_table_id = aws_route_table.private[each.key].id
  subnet_id      = each.value.id
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
  for_each = aws_subnet.db

  route_table_id = aws_route_table.db.id
  subnet_id      = each.value.id
}

########################################
# 6. VPC Endpoints
########################################

data "aws_region" "current" {}

# Gateway endpoint: S3, DynamoDB
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"

  route_table_ids = concat(
    [for rt in aws_route_table.private : rt.id],
    [aws_route_table.db.id]
  )

  tags = merge(var.tags, { Name = "${var.name}-s3-endpoint" })
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"

  route_table_ids = [for rt in aws_route_table.private : rt.id]

  tags = merge(var.tags, { Name = "${var.name}-dynamodb-endpoint" })
}

# Interface endpoints: ECR API, ECR DKR, CloudWatch Logs
locals {
  interface_endpoints = [
    "ecr.api",
    "ecr.dkr",
    "logs"
  ]
}

# Interface endpoints: ECR API, ECR DKR, CloudWatch Logs
resource "aws_security_group" "vpce" {
  name        = "${var.name}-vpce-sg"
  description = "Security group for VPC Interface Endpoints"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "interface" {
  for_each = toset(local.interface_endpoints)

  vpc_id              = aws_vpc.this.id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  subnet_ids          = [for s in aws_subnet.private : s.id]
  private_dns_enabled = true

  security_group_ids = [aws_security_group.vpce.id]

  tags = merge(
    var.tags,
    { Name = "${var.name}-${each.key}-endpoint" }
  )
}
