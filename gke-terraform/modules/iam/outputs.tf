output "gke_node_service_account" {
  value = google_service_account.gke_nodes.email
}
