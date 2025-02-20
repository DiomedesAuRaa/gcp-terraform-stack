resource "google_app_engine_application" "app" {
  project     = var.project_id
  location_id = var.region
}

resource "google_app_engine_service" "service" {
  service_id = "default"
  project    = var.project_id

  split {
    allocations = {
      "v1" = 1.0
    }
  }
}
