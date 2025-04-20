# Network
module "network_create" {
  source = "./modules/network"
}

# Firewall
module "firewall_create" {
  source       = "./modules/firewall"
  network_name = module.network_create.network_name
}

locals {

  # SSH Setup
  ssh_keys = (
    var.ssh_keys != null ?
    var.ssh_keys :
    { "ubuntu" : file("~/.ssh/id_rsa.pub") }
  )
}

# Control plane
module "controller" {
  source       = "./modules/controller"
  vm_names     = var.control_plane_names
  zone         = var.zone
  ssh_keys     = local.ssh_keys
  network_name = module.network_create.control_plane_network_name
}

# Workers
module "worker" {
  source       = "./modules/worker"
  vm_names     = var.worker_node_names
  zone         = var.zone
  ssh_keys     = local.ssh_keys
  network_name = module.network_create.worker_node_network_name
}

resource "local_file" "ansible_inventory" {
  depends_on = [module.controller, module.worker, ]
  content = templatefile(
    "../hosts.ini",
    {
      controllers = module.controller.ips
      workers     = module.worker.ips
    }
  )
  filename = "../inventory.ini"
}
