module "gke" {
  source     = "../../modules/gke"
  region     = var.region
  project_id = var.project_id
}

module "vm" {
  source     = "../../modules/vm"
  region     = var.region
  project_id = var.project_id
}

module "cloud_run" {
  source     = "../../modules/cloud_run"
  region     = var.region
  project_id = var.project_id
}

module "app_engine" {
  source     = "../../modules/app_engine"
  region     = var.region
  project_id = var.project_id
}

module "cloud_sql" {
  source     = "../../modules/cloud_sql"
  region     = var.region
  project_id = var.project_id
}

module "pubsub" {
  source     = "../../modules/pubsub"
  region     = var.region
  project_id = var.project_id
}
