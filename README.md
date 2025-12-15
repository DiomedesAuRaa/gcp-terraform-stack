# GKE Cluster Setup with Terraform

This repository provides Infrastructure as Code (IaC) for deploying Google Kubernetes Engine (GKE) clusters using Terraform. It supports both **development** and **production** environments with proper security controls, CI/CD automation, and reusable modules.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         GCP Project                              │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                    VPC Network                              │ │
│  │  ┌──────────────┐  ┌──────────────────────────────────────┐ │ │
│  │  │Public Subnet │  │         Private Subnet               │ │ │
│  │  │ (Bastion)    │  │  ┌─────────────────────────────────┐ │ │ │
│  │  │              │  │  │         GKE Cluster              │ │ │ │
│  │  │              │  │  │  ┌─────┐ ┌─────┐ ┌─────┐        │ │ │ │
│  │  │              │  │  │  │Node │ │Node │ │Node │        │ │ │ │
│  │  │              │  │  │  └─────┘ └─────┘ └─────┘        │ │ │ │
│  │  │              │  │  └─────────────────────────────────┘ │ │ │
│  │  └──────────────┘  └──────────────────────────────────────┘ │ │
│  └────────────────────────────────────────────────────────────┘ │
│                              │                                   │
│                    ┌─────────┴─────────┐                        │
│                    │    Cloud NAT      │                        │
│                    └───────────────────┘                        │
└─────────────────────────────────────────────────────────────────┘
```

## Features

- ✅ **Multi-environment support** (dev/prod)
- ✅ **Private GKE clusters** with Cloud NAT for outbound traffic
- ✅ **Least-privilege IAM** roles for security
- ✅ **Workload Identity** for pod authentication
- ✅ **Network policies** with Calico
- ✅ **Shielded GKE nodes** with secure boot
- ✅ **CI/CD with GitHub Actions** including PR plan reviews
- ✅ **Reusable Terraform modules**

## Prerequisites

1. **GCP Project** with billing enabled
2. **Service Account** with required permissions
3. **GCS Bucket** for Terraform state storage
4. **GitHub Secrets** configured for CI/CD

### Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `GCP_CREDENTIALS_JSON` | Service account key for dev environment |
| `GCP_PROJECT_ID` | GCP project ID for dev |
| `GCP_CREDENTIALS_JSON_PROD` | Service account key for prod environment |
| `GCP_PROJECT_ID_PROD` | GCP project ID for prod |
| `DISCORD_WEBHOOK_URL` | Discord webhook for notifications (optional) |

## Directory Structure

```
.
├── .github/
│   └── workflows/
│       ├── dev-gke-stack-apply-workflow.yml    # Dev deployment
│       ├── prod-gke-stack-apply-workflow.yml   # Prod deployment (manual)
│       └── terraform-plan-pr.yml               # PR plan reviews
├── modules/                                     # Reusable modules
│   ├── foundation/                             # APIs, Service Accounts
│   ├── network/                                # VPC, Subnets, Firewall
│   └── gke-cluster/                            # GKE Cluster, Node Pools
└── gke-stack/
    └── envs/
        ├── dev/
        │   ├── 00-foundation/
        │   ├── 01-network/
        │   └── 02-cluster/
        └── prod/
            ├── 00-foundation/
            ├── 01-network/
            └── 02-cluster/
```

## Quick Start

### 1. Create the GCS Bucket for Terraform State

```bash
gsutil mb -l us-central1 -b on gs://terraform-state-bucket-skywalker
gsutil versioning set on gs://terraform-state-bucket-skywalker
```

### 2. Deploy via GitHub Actions (Recommended)

1. Push changes to the `main` branch to trigger dev deployment
2. Use the `workflow_dispatch` trigger for manual deployments
3. For production, trigger the prod workflow and confirm with `DEPLOY-PROD`

### 3. Deploy Manually

```bash
cd gke-stack/envs/dev

# Deploy Foundation
cd 00-foundation
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"

# Deploy Network
cd ../01-network
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"

# Deploy Cluster
cd ../02-cluster
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

### 4. Connect to the Cluster

```bash
gcloud container clusters get-credentials dev-cluster \
  --region us-central1 \
  --project YOUR_PROJECT_ID

kubectl get nodes
```

## Module Reference

### Foundation Module

Creates essential GCP resources:
- Enables required APIs (Compute, Container, IAM, etc.)
- Terraform service account with least-privilege roles
- GKE node service account with minimal permissions

### Network Module

Sets up networking infrastructure:
- VPC network with custom subnets
- Private subnet with secondary ranges for pods/services
- Cloud NAT for outbound internet access
- Firewall rules (IAP SSH, internal, health checks)

### GKE Cluster Module

Deploys the Kubernetes cluster:
- Private cluster with optional private endpoint
- Workload Identity enabled
- Network policies (Calico)
- Shielded nodes with secure boot
- Configurable logging and monitoring

## Security Features

| Feature | Description |
|---------|-------------|
| **Private Cluster** | Nodes have no public IPs |
| **IAP SSH** | SSH access only through Identity-Aware Proxy |
| **Least Privilege IAM** | Minimal required permissions |
| **Workload Identity** | Secure pod-to-GCP authentication |
| **Shielded Nodes** | Secure boot and integrity monitoring |
| **Network Policies** | Calico for pod-to-pod restrictions |

## CI/CD Workflows

### Dev Workflow (`dev-gke-stack-apply-workflow.yml`)
- Triggers on push to `main` or manual dispatch
- Automatically deploys all three modules
- Sends Discord notifications

### Prod Workflow (`prod-gke-stack-apply-workflow.yml`)
- Manual trigger only with confirmation
- Requires `DEPLOY-PROD` confirmation
- Uses separate credentials and project

### PR Plan Workflow (`terraform-plan-pr.yml`)
- Runs `terraform plan` on pull requests
- Posts plan results as PR comments
- Warns about production changes

## Customization

### Using the Reusable Modules

```hcl
module "foundation" {
  source = "../../modules/foundation"

  project_id  = var.project_id
  region      = var.region
  environment = "dev"
}

module "network" {
  source = "../../modules/network"

  project_id   = var.project_id
  region       = var.region
  network_name = "my-network"
}

module "cluster" {
  source = "../../modules/gke-cluster"

  project_id                 = var.project_id
  region                     = var.region
  cluster_name               = "my-cluster"
  network_name               = module.network.network_name
  subnetwork_name            = module.network.private_subnet_name
  node_service_account_email = module.foundation.gke_node_service_account_email
}
```

## Troubleshooting

### Common Issues

1. **API not enabled**: Ensure all required APIs are enabled via the foundation module
2. **Quota exceeded**: Check GCP quotas for CPUs, IPs, etc.
3. **Permission denied**: Verify service account has correct IAM roles
4. **State lock**: Check if another Terraform process is running

### Useful Commands

```bash
# Check cluster status
gcloud container clusters describe dev-cluster --region us-central1

# View node pools
gcloud container node-pools list --cluster dev-cluster --region us-central1

# Check firewall rules
gcloud compute firewall-rules list --filter="network:dev-network"
```

## Contributing

1. Create a feature branch
2. Make changes
3. Submit a PR - the plan workflow will run automatically
4. Request review
5. Merge after approval

## License

MIT License
