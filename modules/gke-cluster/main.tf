terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.23"
    }
  }
}

# GKE Cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  network    = var.network_name
  subnetwork = var.subnetwork_name

  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr
  }

  # Set secondary IP ranges for pods and services
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }

  # Enable Workload Identity
  dynamic "workload_identity_config" {
    for_each = var.enable_workload_identity ? [1] : []
    content {
      workload_pool = "${var.project_id}.svc.id.goog"
    }
  }

  release_channel {
    channel = var.release_channel
  }

  # Enable network policy
  dynamic "network_policy" {
    for_each = var.enable_network_policy ? [1] : []
    content {
      enabled  = true
      provider = "CALICO"
    }
  }

  # Enable Shielded Nodes
  node_config {
    shielded_instance_config {
      enable_secure_boot          = var.enable_secure_boot
      enable_integrity_monitoring = var.enable_integrity_monitoring
    }
  }

  # Logging configuration
  logging_config {
    enable_components = var.logging_components
  }

  # Monitoring configuration
  monitoring_config {
    enable_components = var.monitoring_components
    dynamic "managed_prometheus" {
      for_each = var.enable_managed_prometheus ? [1] : []
      content {
        enabled = true
      }
    }
  }

  deletion_protection = var.deletion_protection

  resource_labels = var.labels
}

# Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  project    = var.project_id
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    preemptible  = var.preemptible
    spot         = var.spot

    service_account = var.node_service_account_email

    oauth_scopes = var.oauth_scopes

    metadata = {
      disable-legacy-endpoints = "true"
    }

    shielded_instance_config {
      enable_secure_boot          = var.enable_secure_boot
      enable_integrity_monitoring = var.enable_integrity_monitoring
    }

    tags = concat(["gke-node", "${var.cluster_name}-node"], var.node_tags)

    labels = var.node_labels
  }

  management {
    auto_repair  = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }

  upgrade_settings {
    max_surge       = var.max_surge
    max_unavailable = var.max_unavailable
  }
}
