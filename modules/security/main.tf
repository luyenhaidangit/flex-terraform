########################################
# 1. Security Groups (Base)
########################################

#-----------------------------------------
# 1.1 ALB
#-----------------------------------------
resource "aws_security_group" "alb" {
  name        = "${var.name}-sg-alb"
  description = "Public ALB access"
  vpc_id      = var.vpc_id

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-sg-alb"
  })
}

#-----------------------------------------
# 1.2 APP
#-----------------------------------------
resource "aws_security_group" "app" {
  name        = "${var.name}-sg-app"
  description = "App layer SG"
  vpc_id      = var.vpc_id

  egress {
    description = "Outbound internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-sg-app"
  })
}

#-----------------------------------------
# 1.3 DB
#-----------------------------------------
resource "aws_security_group" "db" {
  name        = "${var.name}-sg-db"
  description = "Database SG"
  vpc_id      = var.vpc_id

  egress {
    description = "Outbound to VPC only"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-sg-db"
  })
}

#-----------------------------------------
# 1.4 Bastion
#-----------------------------------------

resource "aws_security_group" "bastion_sg" {
  name        = "${var.name}-bastion-sg"
  description = "Security Group for Bastion Host (SSM only)"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-bastion-sg"
  })
}

# Outbound only → 443 to VPC (SSM VPC Endpoints)
resource "aws_security_group_rule" "egress_https" {
  type              = "egress"
  description       = "HTTPS to VPC for SSM endpoints"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = aws_security_group.bastion_sg.id
}

########################################
# 2. Security Group Rules
########################################

#-----------------------------------------
# 2.1 ALB Rules (Public Ingress)
#-----------------------------------------
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

#-----------------------------------------
# 2.2 APP Rules (From ALB)
#-----------------------------------------
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

#-----------------------------------------
# 2.3 DB Rules (From APP)
#-----------------------------------------
resource "aws_security_group_rule" "db_from_app" {
  type                     = "ingress"
  description              = "Allow PostgreSQL from App"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app.id
  security_group_id        = aws_security_group.db.id
}

#-----------------------------------------
# 2.4 Extra Rules (Dynamic)
#-----------------------------------------
resource "aws_security_group_rule" "extra" {
  for_each = { for r in var.extra_rules : r.name => r }

  type              = "ingress"
  description       = each.value.name
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = aws_security_group.app.id
}
