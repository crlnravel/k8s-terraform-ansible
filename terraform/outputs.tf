output "all_ips" {
  value = concat(module.controller.ips[0], module.worker.ips[0])
}
