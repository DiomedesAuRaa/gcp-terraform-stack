output "gke_node_service_account_email" {
  description = "The email of the GKE Node Service Account"
  value       = google_service_account.gke_node_sa.email
}

output "gke_node_service_account_id" {
  description = "The ID of the GKE Node Service Account"
  value       = google_service_account.gke_node_sa.id
}

output "terraform_service_account_email" {
  description = "The email of the Terraform Service Account"
  value       = google_service_account.terraform_sa.email
}

output "terraform_service_account_id" {
  description = "The ID of the Terraform Service Account"
  value       = google_service_account.terraform_sa.id
}

output "enabled_apis" {
  description = "List of enabled APIs"
  value       = [for s in google_project_service.services : s.service]
}
