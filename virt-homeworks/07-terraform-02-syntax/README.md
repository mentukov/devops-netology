# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

---

> ## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно)
>
> 1. Подробная инструкция на русском языке содержится [здесь]
> (<https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart>).
> 2. Обратите внимание на период бесплатного использования после регистрации аккаунта.
> 3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки
> базового терраформ конфига.
> 4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, что бы
> не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

### Ответ на задачу 1



```
mentukov@ubuntu:~$ mkdir cloud-terraform
mentukov@ubuntu:~$ cd cloud-terraform/
mentukov@ubuntu:~/cloud-terraform$ touch main.tf
mentukov@ubuntu:~/cloud-terraform$ nano main.tf 
```

```
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "<OAuth>"
  cloud_id  = "<идентификатор облака>"
  folder_id = "<идентификатор каталога>"
  zone      = "<зона доступности по умолчанию>"
}
```
```
mentukov@ubuntu:~/cloud-terraform$ sudo terraform init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Using previously-installed yandex-cloud/yandex v0.83.0

Terraform has been successfully initialized!
```


4. Добавьте переменные окружения

```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)

```

## Задача 2. Создание aws ec2 или yandex_compute_instance через терраформ
>
> 1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.
> 2. Зарегистрируйте провайдер
>    1. для [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). В файл `main.tf` добавьте
>    блок `provider`, а в `versions.tf` блок `terraform` с вложенным блоком `required_providers`. Укажите любой выбранный вами регион
>    внутри блока `provider`.
>    2. либо для [yandex.cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs). Подробную инструкцию можно найти
>    [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
> 3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы указывали
> их в виде переменных окружения.
> 4. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu.  
> 5. В файле `main.tf` создайте рессурс
>    1. либо [ec2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance).
>    Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в первом блоке
>    `Example Usage`, но желательно, указать большее количество параметров.
>    2. либо [yandex_compute_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_image).
> 6. Также в случае использования aws:
>    1. Добавьте data-блоки `aws_caller_identity` и `aws_region`.
>    2. В файл `outputs.tf` поместить блоки `output` с данными об используемых в данный момент:
>        * AWS account ID,
>        * AWS user ID,
>        * AWS регион, который используется в данный момент,
>        * Приватный IP ec2 инстансы,
>        * Идентификатор подсети в которой создан инстанс.  
> 7. Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок.
> В качестве результата задания предоставьте:
> 1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
> 1. Ссылку на репозиторий с исходной конфигурацией терраформа.  

### Ответ на задачу 2

> 1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?

Packer

> 2. Ссылку на репозиторий с исходной конфигурацией терраформа.  



```
mentukov@ubuntu:~/cloud-terraform$ sudo terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.test will be created
  + resource "yandex_compute_instance" "test" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + name                      = "test"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "    "
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.my-network will be created
  + resource "yandex_vpc_network" "my-network" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "my-network"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.my-subnet will be created
  + resource "yandex_vpc_subnet" "my-subnet" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "my-subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_test_vm = (known after apply)
  + internal_ip_address_test_vm = (known after apply)

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform
apply" now.

```