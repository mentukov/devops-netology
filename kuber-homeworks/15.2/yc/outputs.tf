output "test-image-url" {
  value = "https://${yandex_storage_bucket.netology-bucket-test.bucket_domain_name}/Lenna.jpg"
}

output "instance-0-ip" {
  value = yandex_compute_instance_group.ig.instances.0.network_interface.0.ip_address
}

output "instance-1-ip" {
  value = yandex_compute_instance_group.ig.instances.0.network_interface.0.ip_address
}

output "instance-2-ip" {
  value = yandex_compute_instance_group.ig.instances.0.network_interface.0.ip_address
}

output "external_load_balancer_ip" {
  value = yandex_lb_network_load_balancer.load-balancer-1.listener.*.external_address_spec[0].*.address[0]
}