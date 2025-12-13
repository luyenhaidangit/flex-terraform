########################################
# EKS Cluster IAM Role
########################################

resource "aws_iam_role" "cluster" {
  name               = "${var.name}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json

  tags = {
    Name = "${var.name}-eks-cluster-role"
  }
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "cluster_vpc_resource_controller" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

########################################
# 2. EKS Node IAM Role
########################################

resource "aws_iam_role" "node" {
  name               = "${var.name}-eks-node-role"
  assume_role_policy = data.aws_iam_policy_document.node_assume_role.json

  tags = {
    Name = "${var.name}-eks-node-role"
  }
}

resource "aws_iam_role_policy_attachment" "node_worker_policy" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_ecr_policy" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "node_ssm_policy" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

########################################
# 3. EBS CSI Driver IAM Role (IRSA)
########################################

resource "aws_iam_role" "ebs_csi" {
  count = var.enable_ebs_csi_irsa ? 1 : 0

  name               = "${var.name}-irsa-ebs-csi"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role[0].json

  tags = {
    Name = "${var.name}-irsa-ebs-csi"
  }
}

resource "aws_iam_role_policy_attachment" "ebs_csi" {
  count = var.enable_ebs_csi_irsa ? 1 : 0

  role       = aws_iam_role.ebs_csi[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

########################################
# 4. VPC CNI IAM Role (IRSA)
########################################

resource "aws_iam_role" "vpc_cni" {
  count = var.enable_vpc_cni_irsa ? 1 : 0

  name               = "${var.name}-irsa-vpc-cni"
  assume_role_policy = data.aws_iam_policy_document.vpc_cni_assume_role[0].json

  tags = {
    Name = "${var.name}-irsa-vpc-cni"
  }
}

resource "aws_iam_role_policy_attachment" "vpc_cni" {
  count = var.enable_vpc_cni_irsa ? 1 : 0

  role       = aws_iam_role.vpc_cni[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}