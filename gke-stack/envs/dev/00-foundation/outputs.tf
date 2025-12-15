output "gke_node_service_account_email" {
  description = "The email of the GKE Node Service Account"
  value       = google_service_account.gke_node_sa.email
}

output "terraform_service_account_email" {
  description = "The email of the Terraform Service Account"
  value       = google_service_account.terraform_sa.email
}

output "project_id" {
  description = "The project ID"
  value       = var.project_id
}

output "region" {
  description = "The region"
  value       = var.region
}

output "enabled_apis" {
  description = "List of enabled APIs"
  value       = [for s in google_project_service.services : s.service]
}
