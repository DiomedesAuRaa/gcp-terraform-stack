variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The Google Cloud region"
  type        = string
  default     = "us-central1"
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR range for the public subnet"
  type        = string
  default     = "10.10.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR range for the private subnet"
  type        = string
  default     = "10.20.0.0/24"
}

variable "pods_cidr" {
  description = "CIDR range for GKE pods"
  type        = string
  default     = "10.30.0.0/16"
}

variable "services_cidr" {
  description = "CIDR range for GKE services"
  type        = string
  default     = "10.40.0.0/16"
}

variable "master_ipv4_cidr" {
  description = "CIDR range for GKE master (used in firewall rules)"
  type        = string
  default     = "172.16.0.0/28"
}

variable "nat_logging_enabled" {
  description = "Enable NAT logging"
  type        = bool
  default     = false
}
