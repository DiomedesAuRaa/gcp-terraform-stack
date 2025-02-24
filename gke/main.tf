provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_secret_manager_secret_version" "my_secret" {
  secret  = "terraform-service-account"
  version = "latest"
}

# Fetch the Bucket Name from Secret Manager
data "google_secret_manager_secret_version" "tf_state_bucket_name" {
  secret = "tf-state-bucket-name" # Name of the secret in Secret Manager
}

# Output the bucket name
output "tf_state_bucket_name" {
  value = data.google_secret_manager_secret_version.tf_state_bucket_name.secret_data
}

data "google_secret_manager_secret_version" "gcp_project_id" {
  secret = "gcp-project-id"
}

data "google_secret_manager_secret_version" "tf_state_bucket_name" {
  secret = "tf-state-bucket-name"
}

resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnet.name
  depends_on = [google_compute_network.vpc_network, google_compute_subnetwork.subnet]
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "local_file" "secret_output" {
  content  = data.google_secret_manager_secret_version.my_secret.secret_data
  filename = "${path.module}/secret_output.txt"
}