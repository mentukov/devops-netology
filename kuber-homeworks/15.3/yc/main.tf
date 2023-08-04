
resource "yandex_iam_service_account" "sa-bucket" {
  name      = "sa-for-bucket"
}


resource "yandex_resourcemanager_folder_iam_member" "bucket-editor" {
  folder_id = var.yandex_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-bucket.id}"
  depends_on = [yandex_iam_service_account.sa-bucket]
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor-encrypter-decrypter" {
  folder_id = var.yandex_folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.sa-bucket.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa-bucket.id
  description        = "static access key for bucket"
}

resource "yandex_kms_symmetric_key" "key-1" {
  name              = "key-1"
  description       = "ключ для шифрования бакета"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // 1 год
}


resource "yandex_storage_bucket" "netology-bucket-test" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket = "mentukov-netology-bucket-test"
    acl    = "public-read"

  max_size = 1073741824

  anonymous_access_flags {
    read = true
    list = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-1.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
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