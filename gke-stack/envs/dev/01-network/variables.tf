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
