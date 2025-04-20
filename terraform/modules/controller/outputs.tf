output "ips" {
  value = [[for addr in google_compute_address.k8s_ip : addr.address], [for instance in google_compute_instance.k8s_control_plane : instance.network_interface[0].network_ip]]
}
