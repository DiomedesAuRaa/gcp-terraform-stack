output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "cluster_id" {
  description = "The unique identifier of the GKE cluster"
  value       = google_container_cluster.primary.id
}

output "cluster_endpoint" {
  description = "The IP address of the GKE cluster master"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "The public certificate of the cluster's certificate authority"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "cluster_location" {
  description = "The location of the GKE cluster"
  value       = google_container_cluster.primary.location
}

output "node_pool_name" {
  description = "The name of the node pool"
  value       = google_container_node_pool.primary_nodes.name
}

output "get_credentials_command" {
  description = "gcloud command to get cluster credentials"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region} --project ${var.project_id}"
}
