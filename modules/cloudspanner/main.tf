resource "google_spanner_instance" "cloudspanner" {
  name         = "my-cloudspanner-instance"
  config       = "regional-us-central1"
  display_name = "My Cloud Spanner Instance"
  num_nodes    = 1
}
