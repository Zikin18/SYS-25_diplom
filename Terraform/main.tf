data "yandex_resourcemanager_cloud" "cloud-beloborodov-y" {
  name = "cloud-beloborodov-y"
}

data "yandex_resourcemanager_folder" "graduate-work" {
  name     = "graduate-work"
  cloud_id = data.yandex_resourcemanager_cloud.cloud-beloborodov-y.id
}

data "yandex_iam_service_account" "sa-admin" {
  name = "sa-admin"
}