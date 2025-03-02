#!/bin/bash

set -e

BOOTSTRAP_DIR="$(dirname "$0")"

cat <<EOF > "$BOOTSTRAP_DIR/main.tf"
terraform {
  required_version = ">= 1.3.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "terraform_state" {
  name                        = var.bucket_name
  location                    = var.region
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type = "Delete"
    }
  }
}

output "backend_bucket_name" {
  value = google_storage_bucket.terraform_state.name
}
EOF

cat <<EOF > "$BOOTSTRAP_DIR/variables.tf"
variable "project_id" {
  type = string
}

variable "region" {
  type = string
  default = "us-central1"
}

variable "bucket_name" {
  type = string
}
EOF

cat <<EOF > "$BOOTSTRAP_DIR/terraform.tfvars"
project_id = "your-gcp-project-id"
region = "us-central1"
bucket_name = "your-terraform-state-bucket-name"
EOF

cat <<EOF > "$BOOTSTRAP_DIR/versions.tf"
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}
EOF

chmod +x "$BOOTSTRAP_DIR/bootstrap.sh"
echo "Bootstrap files have been created in \$BOOTSTRAP_DIR."