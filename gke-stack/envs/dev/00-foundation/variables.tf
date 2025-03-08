variable "region" {
  description = "The Google Cloud region"
  type        = string
  default     = "us-central1"
}

variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
  default     = "pioneering-coda-451901-i1"
}

variable "node_service_account" {
  description = "The email of the GKE Node Service Account"
  type        = string
  default     = null  
}