variable "region" {
  description = "The Google Cloud region"
  type        = string
  default     = "us-central1"
}

variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "dev-network"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "dev-gke-cluster"
}

variable "node_count" {
  description = "The number of nodes in the GKE cluster"
  type        = number
  default     = 3
}

variable "subnetwork_name" {
  description = "The name of the subnetwork"
  type        = string
  default     = "dev-network-subnet-private"
}
