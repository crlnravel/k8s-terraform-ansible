resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = var.network_name

  direction = "INGRESS"
  priority  = 1001

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_k8s_api" {
  name    = "allow-k8s-api"
  network = var.network_name

  direction = "INGRESS"
  priority  = 1002

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal"
  network = var.network_name

  direction = "INGRESS"
  priority  = 1003

  allow {
    protocol = "all"
  }

  source_ranges      = ["10.0.0.0/24"]
  destination_ranges = ["10.0.0.0/24"]
}
