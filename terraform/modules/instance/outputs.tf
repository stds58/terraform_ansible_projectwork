
output "internal_ip_address" {
  value = yandex_compute_instance.vm.network_interface[0].ip_address
}

output "external_ip_address" {
  value = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}

output "vm_name" {
  value = yandex_compute_instance.vm.name
}

output "vm_labels" {
  value = yandex_compute_instance.vm.labels
}

output "instance_id" {
  value       = yandex_compute_instance.vm.id
}
