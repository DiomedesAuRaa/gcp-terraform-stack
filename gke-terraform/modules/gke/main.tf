resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.region

  network    = var.network
  subnetwork = var.subnetwork

  release_channel {
    channel = "REGULAR"
  }

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.gke_cluster.name
  node_count = var.node_count

  node_config {
    preemptible     = var.preemptible
    machine_type    = var.machine_type
    service_account = var.node_service_account
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
