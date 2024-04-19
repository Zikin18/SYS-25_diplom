resource "yandex_compute_instance" "elasticsearch" {
  name     = "elasticsearch"
  hostname = "elasticsearch"
  platform_id = var.platform
  zone     = var.zone_a

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = var.boot_image
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private-subnet.id
    security_group_ids = [yandex_vpc_security_group.private-group.id]
  }

  metadata = {
    user-data = "${file("./metadata.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}