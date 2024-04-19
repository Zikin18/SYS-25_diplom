terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = var.y_token
  cloud_id  = var.y_cloud
  folder_id = var.y_folder
  zone = var.zone_b
}
