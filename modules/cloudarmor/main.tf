resource "google_compute_security_policy" "cloudarmor" {
  name = "my-cloudarmor-policy"

  rule {
    action   = "allow"
    priority = 1000
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
  }
}
