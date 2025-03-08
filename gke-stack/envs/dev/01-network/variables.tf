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
variable "network_name" {
    description = "The name of the VPC network"
    type        = string
    default     = "dev-network"
}
