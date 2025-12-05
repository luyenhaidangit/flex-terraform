########################################
# 1. Security Groups (Base)
########################################

resource "aws_security_group" "alb" {
  name        = "${var.name}-sg-alb"
  description = "Public ALB access"
  vpc_id      = var.vpc_id

  # Egress: Allow all outbound
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

  # Egress: Allow all outbound (e.g. to NAT GW, S3 endpoint)
  egress {
    description = "Outbound internet"
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

  # Egress: Allow outbound (e.g. for updates if needed, or restrict internal)
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

########################################
# 2. Rules: ALB (Public Ingress)
########################################

resource "aws_security_group_rule" "alb_http" {
  type              = "ingress"
  description       = "HTTP from Internet"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.alb_ingress_cidrs
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_https" {
  type              = "ingress"
  description       = "HTTPS from Internet"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.alb_ingress_cidrs
  security_group_id = aws_security_group.alb.id
}

########################################
# 3. Rules: APP (From ALB)
########################################

resource "aws_security_group_rule" "app_from_alb" {
  type                     = "ingress"
  description              = "Allow HTTP from ALB"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.app.id
}

resource "aws_security_group_rule" "app_from_alb_8080" {
  type                     = "ingress"
  description              = "Allow API 8080 from ALB"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.app.id
}

########################################
# 4. Rules: DB (From APP)
########################################

resource "aws_security_group_rule" "db_from_app" {
  type                     = "ingress"
  description              = "Allow PostgreSQL from App"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app.id
  security_group_id        = aws_security_group.db.id
}

########################################
# 5. Extra Rules (Dynamic)
########################################

resource "aws_security_group_rule" "extra" {
  for_each = { for r in var.extra_rules : r.name => r }

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.app.id
}
