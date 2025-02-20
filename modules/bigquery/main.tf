resource "google_bigquery_dataset" "bigquery" {
  dataset_id = "my_bigquery_dataset"
  location   = var.region
}
