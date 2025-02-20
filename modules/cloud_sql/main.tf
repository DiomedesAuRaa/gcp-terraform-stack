resource "google_sql_database_instance" "instance" {
  name             = "my-cloud-sql-instance"
  database_version = "POSTGRES_14"
  region           = var.region
  settings {
    tier = "db-f1-micro"
  }
}
