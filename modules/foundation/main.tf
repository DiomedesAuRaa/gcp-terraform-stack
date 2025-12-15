terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.23"
    }
  }
}

# Enable Required APIs
resource "google_project_service" "services" {
  for_each = toset(var.enable_apis)

  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}

# Create Service Account for Terraform
resource "google_service_account" "terraform_sa" {
  project      = var.project_id
  account_id   = "${var.environment}-terraform-sa"
  display_name = "Terraform Service Account (${var.environment})"
}

# IAM Binding for Terraform Service Account (least privilege)
resource "google_project_iam_member" "terraform_sa_roles" {
  for_each = toset(var.terraform_sa_roles)

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.terraform_sa.email}"
}

# Create Service Account for GKE Node
resource "google_service_account" "gke_node_sa" {
  project      = var.project_id
  account_id   = "${var.environment}-gke-node-sa"
  display_name = "GKE Node Service Account (${var.environment})"
}

# IAM Binding for GKE Node Service Account
resource "google_project_iam_member" "gke_node_sa_roles" {
  for_each = toset(var.gke_node_sa_roles)

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gke_node_sa.email}"

  depends_on = [google_service_account.gke_node_sa]
}
