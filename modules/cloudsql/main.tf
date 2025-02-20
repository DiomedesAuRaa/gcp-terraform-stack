resource "google_sql_database_instance" "cloudsql" {
  name             = "my-cloudsql-instance"
  region           = var.region
  database_version = "POSTGRES_13"

  settings {
    tier = "db-f1-micro"
  }
}
