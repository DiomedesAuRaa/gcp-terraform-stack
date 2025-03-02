# GKE Terraform Project

This repository manages the infrastructure for GKE clusters using Terraform.

## Structure

- `modules/` contains reusable infrastructure modules.
- `environments/` contains environment-specific configurations (dev, prod, etc.).
- `global/` contains common provider configurations.

## Usage

```sh
cd environments/dev
terraform init
terraform apply
