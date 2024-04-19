resource "yandex_compute_instance" "bastionhost" {
  name        = "bastionhost"
  hostname    = "bastionhost"
  platform_id = var.platform
  zone        = var.zone_d

  resources {
    cores         = 2
    memory        = 1
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
      yandex_vpc_security_group.private-group.id,
      yandex_vpc_security_group.bastion-group.id
      ]
  }

  metadata = {
    user-data = "${file("./metadata.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}