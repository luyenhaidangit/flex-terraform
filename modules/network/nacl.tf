

# CloudWatch logs
/*
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
*/

########################################
# 9. Private NACL
########################################

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.this.id

  subnet_ids = [
    aws_subnet.private.id
  ]

  tags = merge(var.tags, {
    Name = "${var.name}-private-nacl"
    Tier = "private"
  })
}

# Inbound from Public Subnet (ALB)
resource "aws_network_acl_rule" "private_in_from_public" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.public_subnet_cidr
  from_port      = 0
  to_port        = 65535
}

# Outbound HTTPS (call external)
resource "aws_network_acl_rule" "private_out_https" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Outbound Ephemeral
resource "aws_network_acl_rule" "private_out_ephemeral" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

########################################
# 10. DB NACL
########################################

resource "aws_network_acl" "db" {
  vpc_id = aws_vpc.this.id

  subnet_ids = [
    aws_subnet.db.id
  ]

  tags = merge(var.tags, {
    Name = "${var.name}-db-nacl"
    Tier = "db"
  })
}

# Inbound DB port from Private
resource "aws_network_acl_rule" "db_in_postgres" {
  network_acl_id = aws_network_acl.db.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.private_subnet_cidr
  from_port      = 5432
  to_port        = 5432
}

# Outbound Ephemeral (response)
resource "aws_network_acl_rule" "db_out_ephemeral" {
  network_acl_id = aws_network_acl.db.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.private_subnet_cidr
  from_port      = 1024
  to_port        = 65535
}
