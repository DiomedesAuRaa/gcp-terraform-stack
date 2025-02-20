resource "google_container_cluster" "gke" {
  name     = "my-gke-cluster"
  location = var.region
  initial_node_count = 2
  node_config {
    machine_type = "e2-medium"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
