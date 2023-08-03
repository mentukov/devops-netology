
resource "yandex_iam_service_account" "sa-ig" {
    name      = "sa-yc-ig"
}


resource "yandex_resourcemanager_folder_iam_member" "ig-editor" {
    folder_id = var.yandex_folder_id
    role      = "editor"
    member    = "serviceAccount:${yandex_iam_service_account.sa-ig.id}"
}


resource "yandex_compute_instance_group" "ig" {
    name               = "ig-balanced"
    folder_id          = var.yandex_folder_id
    service_account_id = yandex_iam_service_account.sa-ig.id

    instance_template {
        resources {
            cores  = 2
            memory = 1
            core_fraction = 20
        }
        boot_disk {
            initialize_params {
                image_id = "fd827b91d99psvq5fjit"
            }
        }
        network_interface {
            network_id  = yandex_vpc_network.lab-net.id
            subnet_ids  = [yandex_vpc_subnet.subnet-public.id]
            nat         = true
        }
        scheduling_policy {
            preemptible = true
        }
        metadata = {
            ssh-keys   = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
            user-data  = <<EOF
#!/bin/bash
apt install httpd -y
cd /var/www/html
echo '<html><head><title>Netology Test YC site</title></head> <body><h1>15.2 HW Netology</h1><img src="http://${yandex_storage_bucket.netology-bucket-test.bucket_domain_name}/Lenna.jpg"/></body></html>' > index.html
service httpd start
EOF
      }
   }

    scale_policy {
        fixed_scale {
            size = 3
        }
    }

    allocation_policy {
        zones = ["ru-central1-a"]
    }

    deploy_policy {
        max_unavailable  = 1
        max_creating     = 3
        max_expansion    = 1
        max_deleting     = 1
        startup_duration = 3
    }

    health_check {
        http_options {
            port    = 80
            path    = "/"
        }
    }

    depends_on = [
        yandex_storage_bucket.netology-bucket-test
    ]

    load_balancer {
        target_group_name = "target-group"
    }
}