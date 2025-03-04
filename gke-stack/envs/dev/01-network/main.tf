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

# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

# Public Subnet (optional, not needed for GKE but useful for bastion hosts if required)
resource "google_compute_subnetwork" "subnet_public" {
  name                     = "${var.network_name}-subnet-public"
  ip_cidr_range            = "10.10.0.0/24"
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = false
}

# Private Subnet (for GKE Nodes) with Secondary Ranges for Pods and Services
resource "google_compute_subnetwork" "subnet_private" {
  name                     = "${var.network_name}-subnet-private"
  ip_cidr_range            = "10.20.0.0/24"
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.30.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.40.0.0/16"
  }
}

# Firewall Rule - Internal communication between GKE nodes
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.network_name}-allow-internal"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = ["10.0.0.0/8"]
}

# Firewall Rule - Allow SSH (if needed for bastion or admin access)
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.network_name}-allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Firewall Rule - Allow HTTPS (typically for services like IAP or other public access)
resource "google_compute_firewall" "allow_https" {
  name    = "${var.network_name}-allow-https"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Cloud Router for NAT (to provide internet access for private subnet)
resource "google_compute_router" "nat_router" {
  name    = "${var.network_name}-router"
  network = google_compute_network.vpc_network.name
  region  = var.region
}

resource "google_compute_router_nat" "nat_config" {
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = false
    filter = "ERRORS_ONLY"
  }
}

# Outputs - makes your GKE module easier to wire up
output "network_name" {
  value = google_compute_network.vpc_network.name
}

output "private_subnet_name" {
  value = google_compute_subnetwork.subnet_private.name
}

output "private_subnet_self_link" {
  value = google_compute_subnetwork.subnet_private.self_link
}

output "pods_range_name" {
  value = "pods"
}

output "services_range_name" {
  value = "services"
}
