variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
  default     = "pioneering-coda-451901-i1"
}

variable "region" {
  description = "The region where resources will be created."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The zone where the GKE cluster will be deployed."
  type        = string
  default     = "us-central1-a"
}

variable "network_name" {
  description = "The name of the VPC network."
  type        = string
  default     = "my-vpc-network"
}

variable "subnet_name" {
  description = "The name of the subnet."
  type        = string
  default     = "my-subnet"
}

variable "subnet_cidr" {
  description = "The CIDR range for the subnet."
  type        = string
  default     = "10.2.0.0/16"
}

variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
  default     = "my-gke-cluster"
}
