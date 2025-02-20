output "gke_cluster_name" {
  value = var.enable_gke ? module.gke[0].cluster_name : "GKE module disabled"
}

output "bigquery_dataset_id" {
  value = var.enable_bigquery ? module.bigquery[0].dataset_id : "BigQuery module disabled"
}

output "cloudsql_instance_name" {
  value = var.enable_cloudsql ? module.cloudsql[0].instance_name : "Cloud SQL module disabled"
}

output "cloudrun_service_name" {
  value = var.enable_cloudrun ? module.cloudrun[0].service_name : "Cloud Run module disabled"
}

output "cloudarmor_policy_name" {
  value = var.enable_cloudarmor ? module.cloudarmor[0].policy_name : "Cloud Armor module disabled"
}

output "cloudspanner_instance_name" {
  value = var.enable_cloudspanner ? module.cloudspanner[0].instance_name : "Cloud Spanner module disabled"
}

output "cloudcdn_backend_bucket_name" {
  value = var.enable_cloudcdn ? module.cloudcdn[0].backend_bucket_name : "Cloud CDN module disabled"
}

output "compute_instance_name" {
  value = var.enable_compute ? module.compute[0].instance_name : "Compute Engine module disabled"
}
