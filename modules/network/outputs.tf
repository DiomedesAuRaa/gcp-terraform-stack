output "network_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc_network.name
}

output "network_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.vpc_network.id
}

output "network_self_link" {
  description = "The self link of the VPC network"
  value       = google_compute_network.vpc_network.self_link
}

output "private_subnet_name" {
  description = "The name of the private subnet"
  value       = google_compute_subnetwork.subnet_private.name
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = google_compute_subnetwork.subnet_private.id
}

output "private_subnet_self_link" {
  description = "The self link of the private subnet"
  value       = google_compute_subnetwork.subnet_private.self_link
}

output "public_subnet_name" {
  description = "The name of the public subnet"
  value       = google_compute_subnetwork.subnet_public.name
}

output "pods_range_name" {
  description = "The name of the pods secondary range"
  value       = "pods"
}

output "services_range_name" {
  description = "The name of the services secondary range"
  value       = "services"
}

output "router_name" {
  description = "The name of the Cloud Router"
  value       = google_compute_router.nat_router.name
}

output "nat_name" {
  description = "The name of the Cloud NAT"
  value       = google_compute_router_nat.nat_config.name
}
