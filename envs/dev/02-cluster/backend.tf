terraform {
  backend "gcs" {
    bucket = "terraform-state-bucket-skywalker"
    prefix = "envs/dev/02-cluster"
    }
}
