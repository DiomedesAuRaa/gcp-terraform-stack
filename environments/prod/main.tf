module "gke" {
  count  = var.enable_gke ? 1 : 0
  source = "../../modules/gke"
  region = var.region
}

module "bigquery" {
  count  = var.enable_bigquery ? 1 : 0
  source = "../../modules/bigquery"
  region = var.region
}

module "cloudsql" {
  count  = var.enable_cloudsql ? 1 : 0
  source = "../../modules/cloudsql"
  region = var.region
}

module "cloudrun" {
  count  = var.enable_cloudrun ? 1 : 0
  source = "../../modules/cloudrun"
  region = var.region
}

module "cloudarmor" {
  count  = var.enable_cloudarmor ? 1 : 0
  source = "../../modules/cloudarmor"
  region = var.region
}

module "cloudspanner" {
  count  = var.enable_cloudspanner ? 1 : 0
  source = "../../modules/cloudspanner"
  region = var.region
}

module "cloudcdn" {
  count  = var.enable_cloudcdn ? 1 : 0
  source = "../../modules/cloudcdn"
  region = var.region
}

module "compute" {
  count  = var.enable_compute ? 1 : 0
  source = "../../modules/compute"
  region = var.region
}
