terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.23"
    }
  }
}

# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
  project                 = var.project_id
}

# Public Subnet (optional, for bastion hosts if required)
resource "google_compute_subnetwork" "subnet_public" {
  name                     = "${var.network_name}-subnet-public"
  ip_cidr_range            = var.public_subnet_cidr
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = false
  project                  = var.project_id
}

# Private Subnet (for GKE Nodes) with Secondary Ranges for Pods and Services
resource "google_compute_subnetwork" "subnet_private" {
  name                     = "${var.network_name}-subnet-private"
  ip_cidr_range            = var.private_subnet_cidr
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
  project                  = var.project_id

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr
  }
}

# Firewall Rule - Internal communication between GKE nodes
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.network_name}-allow-internal"
  network = google_compute_network.vpc_network.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/8"]
  target_tags   = ["gke-node"]
}

# Firewall Rule - Allow SSH only from IAP (Identity-Aware Proxy)
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.network_name}-allow-ssh-iap"
  network = google_compute_network.vpc_network.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # IAP IP range for secure SSH access
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["allow-ssh"]
}

# Firewall Rule - Allow HTTPS for GKE master to node communication and health checks
resource "google_compute_firewall" "allow_https" {
  name        = "${var.network_name}-allow-https"
  network     = google_compute_network.vpc_network.name
  project     = var.project_id
  description = "Allow HTTPS for load balancer health checks and GKE webhooks"

  allow {
    protocol = "tcp"
    ports    = ["443", "8443", "10250"]
  }

  # GCP health check, load balancer, and master ranges
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22", var.master_ipv4_cidr]
  target_tags   = ["gke-node"]
}

# Cloud Router for NAT (to provide internet access for private subnet)
resource "google_compute_router" "nat_router" {
  name    = "${var.network_name}-router"
  network = google_compute_network.vpc_network.name
  region  = var.region
  project = var.project_id
}

resource "google_compute_router_nat" "nat_config" {
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  project                            = var.project_id
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = var.nat_logging_enabled
    filter = "ERRORS_ONLY"
  }
}
