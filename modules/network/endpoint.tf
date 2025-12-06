########################################
# 6. VPC Endpoints
########################################

# Gateway endpoint: S3, DynamoDB
/*
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
*/

/*
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.this.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"

  route_table_ids = [aws_route_table.private.id]

  tags = merge(var.tags, { Name = "${var.name}-dynamodb-endpoint" })
}
*/

# Interface endpoints: ECR API, ECR DKR, CloudWatch Logs
/*
locals {
  interface_endpoints = [
    "ecr.api",
    "ecr.dkr",
    "logs"
  ]
}
*/

# Interface endpoints: ECR API, ECR DKR, CloudWatch Logs
/*
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
*/