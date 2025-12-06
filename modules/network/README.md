# Network Module

Tạo VPC infrastructure với 3-tier subnet architecture.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                         VPC                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   Public    │  │   Private   │  │     DB      │     │
│  │   Subnet    │  │   Subnet    │  │   Subnet    │     │
│  │  (ALB/NAT)  │  │    (App)    │  │  (Isolated) │     │
│  └──────┬──────┘  └──────┬──────┘  └─────────────┘     │
│         │                │                              │
│         ▼                ▼                              │
│  ┌─────────────┐  ┌─────────────┐                      │
│  │     IGW     │  │  NAT (opt)  │                      │
│  └─────────────┘  └─────────────┘                      │
└─────────────────────────────────────────────────────────┘
```

## Files

| File | Description |
|------|-------------|
| `vpc.tf` | VPC resource |
| `subnet.tf` | Public, Private, DB subnets |
| `internet-gateway.tf` | Internet Gateway |
| `nat-gateway.tf` | NAT Gateway (commented) |
| `route-table.tf` | Route tables & associations |
| `endpoint.tf` | VPC Endpoints (S3, DynamoDB, ECR - commented) |
| `nacl.tf` | Network ACLs for Private & DB |

## Usage

```hcl
module "network" {
  source = "../../modules/network"

  name                = "flex-dev"
  vpc_cidr            = "10.0.0.0/16"
  az                  = "ap-southeast-1a"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  db_subnet_cidr      = "10.0.3.0/24"
  tags                = { Environment = "dev" }
}
```

## Variables

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `name` | string | ✅ | Prefix for naming (`<project>-<env>`) |
| `vpc_cidr` | string | ✅ | VPC CIDR block |
| `az` | string | ✅ | Availability Zone |
| `public_subnet_cidr` | string | ✅ | Public subnet CIDR |
| `private_subnet_cidr` | string | ✅ | Private subnet CIDR |
| `db_subnet_cidr` | string | ✅ | Database subnet CIDR |
| `tags` | map(string) | | Common tags |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | VPC ID |
| `public_subnet_id` | Public subnet ID |
| `private_subnet_id` | Private subnet ID |
| `db_subnet_id` | Database subnet ID |
| `igw_id` | Internet Gateway ID |

## NACL Rules

### Private Subnet
- **Inbound**: All TCP from Public subnet (ALB traffic)
- **Outbound**: HTTPS (443), Ephemeral (1024-65535)

### DB Subnet
- **Inbound**: PostgreSQL (5432) from Private subnet only
- **Outbound**: Ephemeral to Private subnet only

## Optional Features (Commented)

Uncomment để bật:
- **NAT Gateway**: Private subnet → Internet
- **VPC Endpoints**: S3, DynamoDB, ECR, CloudWatch Logs
- **VPC Flow Logs**: Traffic logging

