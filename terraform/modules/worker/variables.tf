variable "vm_names" {
  type    = set(string)
  default = ["worker-node-1", "worker-node-2"]
}

variable "zone" {
  type = string
}

variable "network_name" {
  type = string
}

variable "ssh_keys" {
  type = map(string)
}
