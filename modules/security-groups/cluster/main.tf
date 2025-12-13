########################################
# EKS Cluster Security Group
########################################

resource "aws_security_group" "cluster" {
  name        = "${var.name}-eks-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    { Name = "${var.name}-eks-cluster-sg" }
  )
}

# Allow inbound from nodes
resource "aws_security_group_rule" "cluster_ingress_nodes" {
  type                     = "ingress"
  description              = "Allow nodes to communicate with cluster API"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.node.id
  security_group_id        = aws_security_group.cluster.id
}

# Allow all outbound
resource "aws_security_group_rule" "cluster_egress_all" {
  type              = "egress"
  description       = "Allow all outbound traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster.id
}

########################################
# EKS Node Security Group
########################################

resource "aws_security_group" "node" {
  name        = "${var.name}-eks-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name                                          = "${var.name}-eks-node-sg"
      "kubernetes.io/cluster/${var.name}-cluster"   = "owned"
    }
  )
}

# Node-to-node communication
resource "aws_security_group_rule" "node_ingress_self" {
  type              = "ingress"
  description       = "Allow nodes to communicate with each other"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.node.id
}

# Allow inbound from cluster control plane
resource "aws_security_group_rule" "node_ingress_cluster" {
  type                     = "ingress"
  description              = "Allow cluster control plane to communicate with nodes"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id        = aws_security_group.node.id
}

# Allow inbound from cluster control plane (443 for webhooks)
resource "aws_security_group_rule" "node_ingress_cluster_https" {
  type                     = "ingress"
  description              = "Allow cluster control plane to communicate with nodes (webhooks)"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id        = aws_security_group.node.id
}

# Allow all outbound
resource "aws_security_group_rule" "node_egress_all" {
  type              = "egress"
  description       = "Allow all outbound traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.node.id
}

# Allow CoreDNS (UDP)
resource "aws_security_group_rule" "node_ingress_coredns_udp" {
  type              = "ingress"
  description       = "Allow CoreDNS UDP"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  self              = true
  security_group_id = aws_security_group.node.id
}

# Allow CoreDNS (TCP)
resource "aws_security_group_rule" "node_ingress_coredns_tcp" {
  type              = "ingress"
  description       = "Allow CoreDNS TCP"
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.node.id
}