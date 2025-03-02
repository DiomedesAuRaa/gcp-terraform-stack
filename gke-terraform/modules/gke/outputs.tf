output "cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

output "endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

output "ca_certificate" {
  value = google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate
}
