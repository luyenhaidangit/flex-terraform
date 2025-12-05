resource "aws_security_group" "alb" {
  name        = "${var.name}-sg-alb"
  description = "Public ALB access"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.alb_ingress_cidrs
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.alb_ingress_cidrs
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg-alb"
  }
}

resource "aws_security_group" "app" {
  name        = "${var.name}-sg-app"
  description = "App layer SG"
  vpc_id      = var.vpc_id

  ingress {
    description   = "App HTTP from ALB"
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    security_groups = var.app_ingress_sg_ids
  }

  ingress {
    description   = "App API port"
    from_port     = 8080
    to_port       = 8080
    protocol      = "tcp"
    security_groups = var.app_ingress_sg_ids
  }

  egress {
    description = "Outbound internet (through NAT if private)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg-app"
  }
}

resource "aws_security_group" "db" {
  name        = "${var.name}-sg-db"
  description = "Database SG"
  vpc_id      = var.vpc_id

  ingress {
    description    = "Allow PostgreSQL from App"
    from_port      = 5432
    to_port        = 5432
    protocol       = "tcp"
    security_groups = var.db_ingress_sg_ids
  }

  egress {
    description = "Allow outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg-db"
  }
}

resource "aws_security_group_rule" "extra" {
  for_each = { for r in var.extra_rules : r.name => r }

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.app.id
}
