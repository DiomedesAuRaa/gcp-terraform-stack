variable "project_id" {
  description = "The Google Cloud project ID"
}

variable "region" {
  description = "The Google Cloud region"
}

# # Optional, if you're using these variables
# variable "org_id" {
#   description = "The organization ID"
# }

# variable "billing_account" {
#   description = "The billing account ID"
# }

variable "node_service_account" {
  description = "The email of the GKE Node Service Account"
  type        = string
}
