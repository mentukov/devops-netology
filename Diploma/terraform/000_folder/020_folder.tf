# Create folder.
resource "yandex_resourcemanager_folder" "diploma-folder" {
  name     = var.yandex_folder_id
}
