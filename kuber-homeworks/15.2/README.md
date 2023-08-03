# Домашнее задание к занятию «Вычислительные мощности. Балансировщики нагрузки»  

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашних заданий.

---
## Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать бакет Object Storage и разместить в нём файл с картинкой:

 - Создать бакет в Object Storage с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать файл доступным из интернета.
 
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

 - Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`.
 - Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata).
 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.
 - Настроить проверку состояния ВМ.
 
3. Подключить группу к сетевому балансировщику:

 - Создать сетевой балансировщик.
 - Проверить работоспособность, удалив одну или несколько ВМ.
4. (дополнительно)* Создать Application Load Balancer с использованием Instance group и проверкой состояния.

Полезные документы:

- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group).
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer).
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer).

#### Ответ

```shell
➜  yc git:(main) ✗ terraform apply
yandex_iam_service_account.sa-bucket: Creating...
yandex_iam_service_account.sa-bucket: Creation complete after 4s [id=aje55vpb3q2p9k240mj5]
yandex_resourcemanager_folder_iam_member.bucket-editor: Creating...
yandex_iam_service_account_static_access_key.sa-static-key: Creating...
yandex_iam_service_account_static_access_key.sa-static-key: Creation complete after 1s [id=ajemqs8luet3ik3nvr1r]
yandex_storage_bucket.netology-bucket: Creating...
yandex_resourcemanager_folder_iam_member.bucket-editor: Creation complete after 7s [id=b1gtrdu4ncmc4ev0pqfe/storage.editor/serviceAccount:aje55vpb3q2p9k240mj5]
yandex_storage_bucket.netology-bucket: Still creating... [10s elapsed]
yandex_storage_bucket.netology-bucket: Still creating... [20s elapsed]
yandex_storage_bucket.netology-bucket: Still creating... [30s elapsed]
yandex_storage_bucket.netology-bucket: Still creating... [40s elapsed]
yandex_storage_bucket.netology-bucket: Still creating... [50s elapsed]
yandex_storage_bucket.netology-bucket: Still creating... [1m0s elapsed]
yandex_storage_bucket.netology-bucket: Still creating... [1m10s elapsed]
yandex_storage_bucket.netology-bucket: Still creating... [1m20s elapsed]
yandex_storage_bucket.netology-bucket: Still creating... [1m30s elapsed]
yandex_storage_bucket.netology-bucket: Still creating... [1m40s elapsed]
yandex_storage_bucket.netology-bucket: Still creating... [1m50s elapsed]
yandex_storage_bucket.netology-bucket: Still creating... [2m0s elapsed]
yandex_storage_bucket.netology-bucket: Creation complete after 2m7s [id=mentukov-netology-bucket]
yandex_storage_object.Lenna_object: Creating...
yandex_storage_object.Lenna_object: Creation complete after 2s [id=Lenna.jpg]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

```

https://mentukov-netology-bucket-test.storage.yandexcloud.net/Lenna.jpg

```shell
➜  yc git:(main) ✗ terraform apply
Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

Outputs:

instance-0-ip = "192.168.10.12"
instance-1-ip = "192.168.10.12"
instance-2-ip = "192.168.10.12"
test-image-url = "https://mentukov-netology-bucket.storage.yandexcloud.net/Lenna.jpg"
➜  yc git:(main) ✗ curl 158.160.33.95
<html><head><title>Netology Test YC site</title></head> <body><h1>15.2 HW Netology</h1><img src="http://mentukov-netology-bucket.storage.yandexcloud.net/Lenna.jpg"/></body></html>

➜  yc git:(main) ✗ terraform apply  

Apply complete! Resources: 11 added, 0 changed, 0 destroyed.

Outputs:

external_load_balancer_ip = "158.160.113.9"
instance-0-ip = "192.168.10.10"
instance-1-ip = "192.168.10.10"
instance-2-ip = "192.168.10.10"
test-image-url = "https://mentukov-netology-bucket-test.storage.yandexcloud.net/Lenna.jpg"

```

---