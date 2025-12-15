variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The Google Cloud region"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "enable_apis" {
  description = "List of APIs to enable"
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ]
}

variable "terraform_sa_roles" {
  description = "List of IAM roles for Terraform service account"
  type        = list(string)
  default = [
    "roles/compute.admin",
    "roles/container.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/resourcemanager.projectIamAdmin",
    "roles/storage.admin",
  ]
}

variable "gke_node_sa_roles" {
  description = "List of IAM roles for GKE node service account"
  type        = list(string)
  default = [
    "roles/container.nodeServiceAccount",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/storage.objectViewer",
  ]
}
