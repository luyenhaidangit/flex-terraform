########################################
# EKS Add-ons
########################################

locals {
  # Default add-ons configuration
  default_addons = {
    vpc-cni = {
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = aws_iam_role.vpc_cni.arn
      configuration_values = jsonencode({
        enableNetworkPolicy = "true"
        env = {
          ENABLE_PREFIX_DELEGATION = tostring(var.enable_vpc_cni_prefix_delegation)
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
    coredns = {
      resolve_conflicts    = "OVERWRITE"
      configuration_values = jsonencode({
        replicaCount = 2
        resources = {
          limits = {
            cpu    = "100m"
            memory = "150Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "150Mi"
          }
        }
      })
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = aws_iam_role.ebs_csi.arn
    }
  }

  # Merge default with user-provided add-ons
  addons = merge(local.default_addons, var.cluster_addons)
}

resource "aws_eks_addon" "this" {
  for_each = local.addons

  cluster_name = aws_eks_cluster.this.name
  addon_name   = each.key

  addon_version            = try(each.value.version, null)
  resolve_conflicts_on_create = try(each.value.resolve_conflicts, "OVERWRITE")
  resolve_conflicts_on_update = try(each.value.resolve_conflicts, "OVERWRITE")
  service_account_role_arn = try(each.value.service_account_role_arn, null)
  configuration_values     = try(each.value.configuration_values, null)

  tags = merge(
    var.tags,
    { Name = "${var.name}-${each.key}" }
  )

  depends_on = [
    aws_eks_node_group.this
  ]
}

