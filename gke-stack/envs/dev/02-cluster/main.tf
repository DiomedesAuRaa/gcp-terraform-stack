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

# Data source to fetch the existing VPC network from GCP
data "google_compute_network" "network" {
  name    = var.network_name
  project = var.project_id
}

# Data source to fetch the existing private subnet from GCP
data "google_compute_subnetwork" "subnet_private" {
  name    = var.subnetwork_name
  region  = var.region
  project = var.project_id
}

# Data source to fetch the GKE Node Service Account from GCP
data "google_service_account" "gke_node_sa" {
  account_id = "gke-node-sa"  # Ensure this matches your actual SA name
  project    = var.project_id
}

# GKE Cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  network    = data.google_compute_network.network.name
  subnetwork = data.google_compute_subnetwork.subnet_private.name

  remove_default_node_pool = true
  initial_node_count       = 1  # Required placeholder

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"  # Adjust if needed
  }

  # Set secondary IP ranges for pods and services
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"       # This must match the actual secondary range name
    services_secondary_range_name = "services"   # Same here
  }

  release_channel {
    channel = "REGULAR"
  }

  deletion_protection = false
}

# Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = var.node_count

  node_config {
    machine_type = "e2-standard-2"  
    disk_size_gb = 50  
    preemptible  = false
    service_account = data.google_service_account.gke_node_sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}