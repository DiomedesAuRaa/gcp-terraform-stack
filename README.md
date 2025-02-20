# GCP Terraform Deployment

This repository contains Terraform configurations for deploying:

- Google Kubernetes Engine (GKE)
- BigQuery
- Cloud SQL
- Cloud Run
- Cloud Armor
- Cloud Spanner
- Cloud CDN
- Google Compute Engine

## Prerequisites
- Install [Terraform](https://developer.hashicorp.com/terraform/downloads)
- Install [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- Configure GCP credentials:
  ```sh
  gcloud auth application-default login
  ```

## Deploying All Services
1. Navigate to the environment (`dev` or `prod`):
   ```sh
   cd environments/dev
   ```
2. Initialize Terraform:
   ```sh
   terraform init
   ```
3. Apply the configuration:
   ```sh
   terraform apply -auto-approve
   ```
4. The output will display service details.

## Selective Module Deployment
To enable or disable specific modules, pass the appropriate variables. For example, to only deploy GKE and BigQuery:
```sh
terraform apply \
  -var="enable_gke=true" \
  -var="enable_bigquery=true" \
  -var="enable_cloudsql=false" \
  -var="enable_cloudrun=false" \
  -var="enable_cloudarmor=false" \
  -var="enable_cloudspanner=false" \
  -var="enable_cloudcdn=false" \
  -var="enable_compute=false"
```

## Destroying Resources
```sh
terraform destroy -auto-approve
```
Run this in the environment directory.
