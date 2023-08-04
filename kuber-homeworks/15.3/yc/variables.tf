variable "yandex_cloud_id" {
  default = "b1g9n2954g517s16gite"
}

variable "yandex_folder_id" {
  default = "b1gtrdu4ncmc4ev0pqfe"
}

variable "domain" {
  default = "netology.ycloud"
}

variable "user_name" {
  description = "VM User Name"
  default     = "ubuntu"
}

variable "user_ssh_key_path" {
  description = "User's SSH public key file"
  default     = "~/.ssh/id_rsa.pub"
}