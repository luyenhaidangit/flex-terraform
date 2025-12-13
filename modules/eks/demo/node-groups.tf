########################################
# EKS Managed Node Groups
########################################

resource "aws_eks_node_group" "this" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.name}-${each.key}"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids

  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type
  disk_size      = each.value.disk_size

  scaling_config {
    desired_size = each.value.desired_size
    min_size     = each.value.min_size
    max_size     = each.value.max_size
  }

  update_config {
    max_unavailable_percentage = 25
  }

  labels = merge(
    { "node-group" = each.key },
    each.value.labels
  )

  dynamic "taint" {
    for_each = each.value.taints
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  # Use launch template for additional customization
  launch_template {
    id      = aws_launch_template.node[each.key].id
    version = aws_launch_template.node[each.key].latest_version
  }

  tags = merge(
    var.tags,
    {
      Name                                          = "${var.name}-${each.key}"
      "kubernetes.io/cluster/${var.name}-cluster"   = "owned"
    }
  )

  # Ensure proper dependencies
  depends_on = [
    aws_iam_role_policy_attachment.node_worker_policy,
    aws_iam_role_policy_attachment.node_cni_policy,
    aws_iam_role_policy_attachment.node_ecr_policy,
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

########################################
# Launch Template for Node Groups
########################################

resource "aws_launch_template" "node" {
  for_each = var.node_groups

  name = "${var.name}-${each.key}-lt"

  vpc_security_group_ids = [aws_security_group.node.id]

  # Enable IMDSv2 (best practice)
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  # Enable monitoring
  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name                                          = "${var.name}-${each.key}-node"
        "kubernetes.io/cluster/${var.name}-cluster"   = "owned"
      }
    )
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(
      var.tags,
      { Name = "${var.name}-${each.key}-volume" }
    )
  }

  tags = merge(
    var.tags,
    { Name = "${var.name}-${each.key}-lt" }
  )
}

