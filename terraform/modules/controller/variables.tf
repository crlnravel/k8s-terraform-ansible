variable "vm_names" {
  type = set(string)
  default = [ "control-plane-1" ]
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
