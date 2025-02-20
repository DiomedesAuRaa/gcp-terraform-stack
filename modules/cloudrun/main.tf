resource "google_cloud_run_service" "cloudrun" {
  name     = "my-cloudrun-service"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
      }
    }
  }
}
