resource "yandex_compute_instance" "zabbix" {
  name     = "zabbix"
  hostname = "zabbix"
  platform_id = var.platform
  zone     = var.zone_d
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }
  
  boot_disk {
    initialize_params {
      image_id = var.boot_image
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public-subnet.id
    nat                = true
    security_group_ids = [
      yandex_vpc_security_group.zabbix.id,
      yandex_vpc_security_group.private-group.id]
  }
  metadata = {
    user-data = "${file("./metadata.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }
}