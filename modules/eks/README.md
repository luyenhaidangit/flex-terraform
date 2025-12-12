# EKS Module

Terraform module để triển khai Amazon EKS cluster theo AWS best practices.

## Features

- **EKS Cluster** với private/public endpoint configuration
- **Managed Node Groups** với launch template và auto-scaling
- **KMS encryption** cho Kubernetes secrets
- **IRSA** (IAM Roles for Service Accounts) support
- **EKS Add-ons**: VPC CNI, CoreDNS, kube-proxy, EBS CSI Driver
- **AWS Load Balancer Controller** IRSA setup
- **External DNS** IRSA setup
- **Karpenter** for node autoscaling (optional)

## Usage

```hcl
module "eks" {
  source = "../../modules/eks"

  name            = "my-cluster"
  cluster_version = "1.31"

  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids

  # Private endpoint only (production)
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  # Node Groups
  node_groups = {
    main = {
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      disk_size      = 50
      desired_size   = 2
      min_size       = 1
      max_size       = 10
      labels         = {}
      taints         = []
    }
  }

  # Enable controllers
  enable_alb_controller = true
  enable_external_dns   = true
  enable_karpenter      = true

  tags = {
    Environment = "production"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |
| tls | >= 4.0 |

## Prerequisites

1. **Network**: VPC với ít nhất 2 AZs, NAT Gateway enabled
2. **Subnet Tags** cho EKS auto-discovery:
   - Private subnets: `kubernetes.io/role/internal-elb = 1`
   - Public subnets: `kubernetes.io/role/elb = 1`

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| name | Name prefix for all resources | string | - |
| cluster_version | Kubernetes version | string | "1.31" |
| vpc_id | VPC ID | string | - |
| private_subnet_ids | List of private subnet IDs | list(string) | - |
| cluster_endpoint_private_access | Enable private endpoint | bool | true |
| cluster_endpoint_public_access | Enable public endpoint | bool | false |
| node_groups | Map of node group configurations | map(object) | - |
| enable_alb_controller | Enable ALB Controller IRSA | bool | false |
| enable_external_dns | Enable External DNS IRSA | bool | false |
| enable_karpenter | Enable Karpenter | bool | false |

## Outputs

| Name | Description |
|------|-------------|
| cluster_name | EKS cluster name |
| cluster_endpoint | EKS cluster API endpoint |
| oidc_provider_arn | OIDC provider ARN for IRSA |
| node_security_group_id | Node security group ID |
| alb_controller_role_arn | ALB Controller IAM role ARN |
| external_dns_role_arn | External DNS IAM role ARN |
| karpenter_role_arn | Karpenter IAM role ARN |
| kubectl_config | kubectl configuration command |

## Post-deployment Steps

### 1. Configure kubectl

```bash
aws eks update-kubeconfig --region ap-southeast-1 --name dev-flex-cluster
```

### 2. Install AWS Load Balancer Controller (Helm)

```bash
helm repo add eks https://aws.github.io/eks-charts
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=dev-flex-cluster \
  --set serviceAccount.create=true \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=<alb_controller_role_arn>
```

### 3. Install External DNS (Helm)

```bash
helm repo add external-dns https://kubernetes-sigs.github.io/external-dns
helm install external-dns external-dns/external-dns \
  -n kube-system \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=<external_dns_role_arn>
```

### 4. Install Karpenter (Helm)

```bash
helm repo add karpenter https://charts.karpenter.sh
helm install karpenter karpenter/karpenter \
  -n karpenter --create-namespace \
  --set settings.clusterName=dev-flex-cluster \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=<karpenter_role_arn> \
  --set settings.interruptionQueue=<karpenter_queue_name>
```

## Security Best Practices

- ✅ Private API endpoint (no public access)
- ✅ KMS encryption for secrets
- ✅ IMDSv2 required on nodes
- ✅ IRSA for pod-level IAM permissions
- ✅ Network policies enabled (VPC CNI)
- ✅ Control plane logging enabled
- ✅ SSM access for node debugging
