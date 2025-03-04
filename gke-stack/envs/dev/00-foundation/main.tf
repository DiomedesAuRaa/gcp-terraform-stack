terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.23"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable Required APIs
resource "google_project_service" "services" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ])
  project = var.project_id
  service = each.key
  disable_on_destroy = false
}

# Create Service Account for Terraform 
resource "google_service_account" "terraform_sa" {
  project      = var.project_id
  account_id   = "terraform-service-account"
  display_name = "Terraform Service Account"
}

# IAM Binding for Terraform Service Account
resource "google_project_iam_member" "terraform_sa_roles" {
  for_each = toset([
    "roles/owner",  
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.terraform_sa.email}"
}

# Create Service Account for GKE Node
resource "google_service_account" "gke_node_sa" {
  project      = var.project_id
  account_id   = "gke-node-sa"
  display_name = "GKE Node Service Account"
}

# IAM Binding for GKE Node Service Account
resource "google_project_iam_member" "gke_node_sa_roles" {
  for_each = toset([
    "roles/container.nodeServiceAccount",
    "roles/storage.admin"
  ])

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gke_node_sa.email}"

  # Ensure the IAM policy is applied only after the service account is created
  depends_on = [google_service_account.gke_node_sa]
}

# Output the GKE Node Service Account Email for later use in 02-cluster
output "gke_node_service_account_email" {
  value = google_service_account.gke_node_sa.email
}