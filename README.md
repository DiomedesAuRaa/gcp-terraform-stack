# Google Cloud Terraform Deployment

This repository contains Terraform configurations for deploying:

- Google Kubernetes Engine (GKE)
- Google Compute Engine (VM)
- Google Cloud Run
- Google App Engine
- Google Cloud SQL
- Google Pub/Sub

## Prerequisites
- Install [Terraform](https://developer.hashicorp.com/terraform/downloads)
- Install [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- Authenticate with Google Cloud:
  ```sh
  gcloud auth application-default login
  gcloud config set project "<your-project-id>"
  ```

## Deploying All Services
1. Navigate to the environment ( or ):
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
4. The output will display URLs and service details.

## Destroying Resources
```sh
terraform destroy -auto-approve
```
Run this in the environment directory.
# gcp-terraform-stack
