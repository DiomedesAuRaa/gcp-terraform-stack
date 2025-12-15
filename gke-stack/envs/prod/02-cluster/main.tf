terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.23"
    }
  }

  backend "gcs" {
    bucket = "terraform-state-bucket-skywalker"
    prefix = "envs/prod/02-cluster"
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
  account_id = "gke-node-sa"
  project    = var.project_id
}

# GKE Cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  network    = data.google_compute_network.network.name
  subnetwork = data.google_compute_subnetwork.subnet_private.name

  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  # Set secondary IP ranges for pods and services
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  # Enable Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "STABLE"
  }

  # Enable network policy
  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  # Enable Shielded Nodes
  node_config {
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }

  # Logging and monitoring
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
    managed_prometheus {
      enabled = true
    }
  }

  deletion_protection = true
}

# Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = "pd-ssd"
    preemptible  = false
    spot         = false

    service_account = data.google_service_account.gke_node_sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    tags = ["gke-node", "${var.cluster_name}-node"]

    labels = {
      environment = "prod"
      cluster     = var.cluster_name
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
}
