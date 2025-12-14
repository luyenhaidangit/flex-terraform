########################################
# SSM VPC Endpoints Security Group
########################################

resource "aws_security_group" "ssm_vpce" {
  name        = "${var.name}-ssm-vpce-sg"
  description = "Security Group for SSM VPC Interface Endpoints"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-ssm-vpce-sg"
  }
}

# Ingress: HTTPS from VPC
resource "aws_security_group_rule" "ingress_https" {
  type              = "ingress"
  description       = "HTTPS from VPC"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
  security_group_id = aws_security_group.ssm_vpce.id
}

# Egress: All outbound
resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  description       = "All outbound"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ssm_vpce.id
}