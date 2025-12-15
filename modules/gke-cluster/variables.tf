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

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnetwork_name" {
  description = "The name of the subnetwork"
  type        = string
}

variable "node_service_account_email" {
  description = "The email of the service account for GKE nodes"
  type        = string
}

variable "node_count" {
  description = "The number of nodes in the GKE cluster"
  type        = number
  default     = 3
}

variable "machine_type" {
  description = "The machine type for the node pool"
  type        = string
  default     = "e2-standard-2"
}

variable "disk_size_gb" {
  description = "The disk size in GB for each node"
  type        = number
  default     = 50
}

variable "disk_type" {
  description = "The disk type for each node (pd-standard, pd-ssd, pd-balanced)"
  type        = string
  default     = "pd-standard"
}

variable "preemptible" {
  description = "Whether to use preemptible VMs"
  type        = bool
  default     = false
}

variable "spot" {
  description = "Whether to use spot VMs"
  type        = bool
  default     = false
}

variable "master_ipv4_cidr" {
  description = "CIDR range for GKE master"
  type        = string
  default     = "172.16.0.0/28"
}

variable "pods_range_name" {
  description = "Name of the secondary range for pods"
  type        = string
  default     = "pods"
}

variable "services_range_name" {
  description = "Name of the secondary range for services"
  type        = string
  default     = "services"
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for the cluster master"
  type        = bool
  default     = false
}

variable "enable_workload_identity" {
  description = "Enable Workload Identity"
  type        = bool
  default     = true
}

variable "enable_network_policy" {
  description = "Enable network policy (Calico)"
  type        = bool
  default     = true
}

variable "enable_secure_boot" {
  description = "Enable secure boot for nodes"
  type        = bool
  default     = true
}

variable "enable_integrity_monitoring" {
  description = "Enable integrity monitoring for nodes"
  type        = bool
  default     = true
}

variable "release_channel" {
  description = "Release channel for the cluster (RAPID, REGULAR, STABLE)"
  type        = string
  default     = "REGULAR"
}

variable "logging_components" {
  description = "List of logging components to enable"
  type        = list(string)
  default     = ["SYSTEM_COMPONENTS", "WORKLOADS"]
}

variable "monitoring_components" {
  description = "List of monitoring components to enable"
  type        = list(string)
  default     = ["SYSTEM_COMPONENTS"]
}

variable "enable_managed_prometheus" {
  description = "Enable managed Prometheus"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "auto_repair" {
  description = "Enable auto repair for nodes"
  type        = bool
  default     = true
}

variable "auto_upgrade" {
  description = "Enable auto upgrade for nodes"
  type        = bool
  default     = true
}

variable "max_surge" {
  description = "Max surge for node upgrades"
  type        = number
  default     = 1
}

variable "max_unavailable" {
  description = "Max unavailable for node upgrades"
  type        = number
  default     = 0
}

variable "oauth_scopes" {
  description = "OAuth scopes for nodes"
  type        = list(string)
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "node_tags" {
  description = "Additional network tags for nodes"
  type        = list(string)
  default     = []
}

variable "node_labels" {
  description = "Labels for nodes"
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "Labels for the cluster"
  type        = map(string)
  default     = {}
}
