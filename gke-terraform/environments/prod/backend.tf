terraform {
  backend "gcs" {
    bucket = "terraform-state"
    prefix = "prod/gke"
  }
}
