terraform {
  backend "gcs" {
    bucket = "terraform-state-bucket-skywalker"
    prefix = "global"
  }
}
