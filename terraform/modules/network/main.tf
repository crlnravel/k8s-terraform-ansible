resource "google_compute_network" "k8s_network" {
  name                    = "k8s-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "k8s_control_plane" {
  name          = "control-plane-subnet"
  ip_cidr_range = "10.0.0.0/27"
  network       = google_compute_network.k8s_network.id
}

resource "google_compute_subnetwork" "k8s_worker_nodes" {
  name          = "worker-nodes-subnet"
  ip_cidr_range = "10.0.0.32/27"
  network       = google_compute_network.k8s_network.id
}
