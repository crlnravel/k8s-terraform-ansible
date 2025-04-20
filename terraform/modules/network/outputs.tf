output "network_name" {
  value = google_compute_network.k8s_network.name
}

output "control_plane_network_name" {
  value = google_compute_subnetwork.k8s_control_plane.name
}

output "worker_node_network_name" {
  value = google_compute_subnetwork.k8s_worker_nodes.name
}
