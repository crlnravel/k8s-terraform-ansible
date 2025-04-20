variable "project_name" {
  type    = string
  default = "belajar-kube-457207"
}

variable "region" {
  type    = string
  default = "asia-southeast1"
}

variable "zone" {
  type    = string
  default = "asia-southeast1-a"
}

variable "control_plane_names" {
  type    = set(string)
  default = ["control-plane-1"]
}

variable "worker_node_names" {
  type    = set(string)
  default = ["worker-node-1", "worker-node-2"]
}

variable "ssh_keys" {
  type = map(string)
  default = null
}
