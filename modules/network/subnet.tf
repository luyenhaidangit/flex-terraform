########################################
# 1. Public subnets (one per AZ)
########################################

resource "aws_subnet" "public" {
  count = length(var.azs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-public-${var.azs[count.index]}"
      Tier = "public"
    },
    var.enable_eks_tags ? {
      "kubernetes.io/role/elb"                      = "1"
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    } : {}
  )
}

########################################
# 2. Private subnets (one per AZ)
########################################

resource "aws_subnet" "private" {
  count = length(var.azs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-private-${var.azs[count.index]}"
      Tier = "app"
    },
    var.enable_eks_tags ? {
      "kubernetes.io/role/internal-elb"             = "1"
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    } : {}
  )
}

########################################
# 3. DB subnets (one per AZ)
########################################

resource "aws_subnet" "db" {
  count = length(var.azs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.db_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-db-${var.azs[count.index]}"
      Tier = "db"
    }
  )
}