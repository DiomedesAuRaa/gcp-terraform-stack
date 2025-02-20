terraform {
  required_version = ">= 1.3.0"

  backend "gcs" {
    bucket  = "terraform-state-bucket"
    prefix  = "gcp/terraform.tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
