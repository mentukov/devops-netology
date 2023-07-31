
data "yandex_compute_image" "vm_image" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "instance-nat" {
  name     = "instance-nat-vm"
  platform_id = "standard-v1"
  hostname = "instance-nat-vm.${var.domain}"
  zone     = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id    = "fd80mrhj8fl2oe87o4e1"
      size        = "40"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-public.id
    ip_address = var.instance-nat-ip
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "public-vm" {
  name     = "instance-public-vm"
  hostname = "instance-public-vm.${var.domain}"
  zone     = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.vm_image.id
      size        = "20"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-public.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}


resource "yandex_compute_instance" "private-vm" {
  name     = "instance-private-vm"
  hostname = "instance-private-vm.${var.domain}"
  zone     = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.vm_image.id
      size        = "20"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-private.id
    nat       = false
  }

variable "encrypted_password" {
  description = "Encrypted password for the user 'ubuntu'"
}

  metadata = {
    user_data = <<-EOT
      #cloud-config
      users:
        - name: ubuntu
          passwd: "${var.encrypted_password}"
          shell: /bin/bash
    EOT
  }
}