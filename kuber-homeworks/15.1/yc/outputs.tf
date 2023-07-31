output "internal_ip_address_nat_vm" {
  value = yandex_compute_instance.instance-nat.network_interface.0.ip_address
}

output "external_ip_address_nat_vm" {
  value = yandex_compute_instance.instance-nat.network_interface.0.nat_ip_address
}

output "internal_ip_address_public_vm" {
  value = yandex_compute_instance.public-vm.network_interface.0.ip_address
}

output "external_ip_address_public_vm" {
  value = yandex_compute_instance.public-vm.network_interface.0.nat_ip_address
}

output "internal_ip_address_private_vm" {
  value = yandex_compute_instance.private-vm.network_interface.0.ip_address
}

output "external_ip_address_private_vm" {
  value = yandex_compute_instance.private-vm.network_interface.0.nat_ip_address
}
