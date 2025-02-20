output "gke_name" { value = module.gke.cluster_name }
output "vm_public_ip" { value = module.vm.public_ip }
output "cloud_run_url" { value = module.cloud_run.url }
output "app_engine_url" { value = module.app_engine.url }
output "cloud_sql_instance" { value = module.cloud_sql.instance_name }
output "pubsub_topic" { value = module.pubsub.topic_name }
