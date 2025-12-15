variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The Google Cloud region"
  type        = string
  default     = "us-central1"
}

variable "org_id" {
  description = "The Google Cloud organization ID"
  type        = string
  default     = ""
}

variable "billing_account" {
  description = "The billing account ID"
  type        = string
  default     = ""
}
