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

########################################
# 4. NAT Gateway (1 per AZ — best practice)
########################################

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = merge(
    var.tags,
    { Name = "${var.name}-nat-eip-${var.az}" }
  )
}

resource "aws_nat_gateway" "nat" {
  for_each = aws_subnet.public

  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = merge(
    var.tags,
    { Name = "${var.name}-nat" }
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
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id
}

# Private RT → NAT per AZ
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

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

########################################
# 6. VPC Endpoints
########################################

data "aws_region" "current" {}

# Gateway endpoint: S3, DynamoDB
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"

  # private + db
  route_table_ids = [
    aws_route_table.private.id,
    aws_route_table.db.id
  ]

  tags = merge(var.tags, { Name = "${var.name}-s3-endpoint" })
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"

  route_table_ids = [aws_route_table.private.id]

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
  subnet_ids          = [aws_subnet.private.id]
  private_dns_enabled = true

  security_group_ids = [aws_security_group.vpce.id]

  tags = merge(
    var.tags,
    { Name = "${var.name}-${each.key}-endpoint" }
  )
}

# CloudWatch logs
resource "aws_cloudwatch_log_group" "vpc_flow" {
  name              = "/aws/vpc/${var.name}-flow-logs"
  retention_in_days = 30
}

resource "aws_flow_log" "vpc_flow" {
  log_destination_type = "cloud-watch-logs"
  log_group_name       = aws_cloudwatch_log_group.vpc_flow.name
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.this.id
}
