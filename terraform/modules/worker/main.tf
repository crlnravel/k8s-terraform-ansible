resource "google_compute_address" "k8s_ip" {
  for_each = var.vm_names
  name     = "${each.key}-ip"
}

resource "google_compute_instance" "k8s_worker_node" {
  for_each     = var.vm_names
  name         = each.key
  machine_type = "e2-small"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    subnetwork = var.network_name

    access_config {
      nat_ip = google_compute_address.k8s_ip[each.key].address
    }
  }

  metadata = {
    ssh-keys = join(" ", [for key, value in var.ssh_keys : format("%s:%s", key, value)])
  }

  zone = var.zone
}
