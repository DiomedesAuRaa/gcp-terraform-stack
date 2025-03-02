module "vpc" {
  source = "../../modules/vpc"
  region = var.region
}

module "iam" {
  source = "../../modules/iam"
}

module "gke" {
  source              = "../../modules/gke"
  cluster_name        = "dev-gke-cluster"
  region              = var.region
  network             = module.vpc.network_name
  subnetwork          = module.vpc.subnet_name
  node_service_account = module.iam.gke_node_service_account
}
