variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The Google Cloud region"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "node_count" {
  description = "The number of nodes in the GKE cluster"
  type        = number
  default     = 3
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnetwork_name" {
  description = "The name of the subnetwork"
  type        = string
}

variable "machine_type" {
  description = "The machine type for the node pool"
  type        = string
  default     = "e2-standard-4"
}

variable "disk_size_gb" {
  description = "The disk size in GB for each node"
  type        = number
  default     = 100
}
