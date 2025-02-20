resource "google_cloud_run_service" "service" {
  name     = "my-cloud-run-service"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
      }
    }
  }
}

resource "google_cloud_run_domain_mapping" "mapping" {
  location = var.region
  service  = google_cloud_run_service.service.name

  metadata {
    namespace = var.project_id
  }
}
