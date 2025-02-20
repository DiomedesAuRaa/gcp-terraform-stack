variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "my-gcp-project"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "enable_gke" {
  description = "Enable or disable the GKE module"
  type        = bool
  default     = true
}

variable "enable_bigquery" {
  description = "Enable or disable the BigQuery module"
  type        = bool
  default     = true
}

variable "enable_cloudsql" {
  description = "Enable or disable the Cloud SQL module"
  type        = bool
  default     = true
}

variable "enable_cloudrun" {
  description = "Enable or disable the Cloud Run module"
  type        = bool
  default     = true
}

variable "enable_cloudarmor" {
  description = "Enable or disable the Cloud Armor module"
  type        = bool
  default     = true
}

variable "enable_cloudspanner" {
  description = "Enable or disable the Cloud Spanner module"
  type        = bool
  default     = true
}

variable "enable_cloudcdn" {
  description = "Enable or disable the Cloud CDN module"
  type        = bool
  default     = true
}

variable "enable_compute" {
  description = "Enable or disable the Compute Engine module"
  type        = bool
  default     = true
}
