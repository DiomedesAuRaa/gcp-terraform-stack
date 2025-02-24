output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_region" {
  value = var.region
}

output "cluster_zone" {
  value = var.zone
}

output "network_name" {
  value = google_compute_network.vpc_network.name
}

output "subnet_name" {
  value = google_compute_subnetwork.subnet.name
}

output "secret_value" {
  value     = data.google_secret_manager_secret_version.my_secret.secret_data
  sensitive = true
}
