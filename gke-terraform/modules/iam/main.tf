resource "google_service_account" "gke_nodes" {
  account_id   = "gke-nodes-sa"
  display_name = "GKE Nodes Service Account"
}

resource "google_project_iam_member" "gke_nodes_roles" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer"
  ])
  role    = each.value
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}
