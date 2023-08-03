
resource "yandex_iam_service_account" "sa-bucket" {
  name      = "sa-for-bucket"
}


resource "yandex_resourcemanager_folder_iam_member" "bucket-editor" {
  folder_id = var.yandex_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-bucket.id}"
  depends_on = [yandex_iam_service_account.sa-bucket]
}


resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa-bucket.id
  description        = "static access key for bucket"
}

resource "yandex_storage_bucket" "netology-bucket-test" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket = "mentukov-netology-bucket-test"
    acl    = "public-read"
}


resource "yandex_storage_object" "Lenna_object" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket = yandex_storage_bucket.netology-bucket-test.bucket
    key = "Lenna.jpg"
    source = "pic/Lenna.jpg"
    acl    = "public-read"
    depends_on = [yandex_storage_bucket.netology-bucket-test]
}