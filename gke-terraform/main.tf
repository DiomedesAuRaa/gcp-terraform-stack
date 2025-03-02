terraform {
  required_version = ">= 1.3.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "terraform_state" {
  name                        = var.bucket_name
  location                    = var.region
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type = "Delete"
    }
  }
}

output "backend_bucket_name" {
  value = google_storage_bucket.terraform_state.name
}
