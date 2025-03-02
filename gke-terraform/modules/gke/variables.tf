variable "cluster_name" {}
variable "region" {}
variable "network" {}
variable "subnetwork" {}
variable "node_count" { default = 3 }
variable "machine_type" { default = "e2-medium" }
variable "node_service_account" {}
variable "preemptible" { default = false }
