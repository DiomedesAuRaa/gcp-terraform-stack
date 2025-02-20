resource "google_compute_backend_bucket" "cloudcdn" {
  name        = "my-cloudcdn-backend-bucket"
  bucket_name = google_storage_bucket.cloudcdn_bucket.name
  enable_cdn  = true
}

resource "google_storage_bucket" "cloudcdn_bucket" {
  name     = "my-cloudcdn-bucket"
  location = var.region
}
