resource "yandex_alb_target_group" "webservers-target-group" {
  name = "webservers-target-group"
  target {
    ip_address = yandex_compute_instance.webserver1.network_interface.0.ip_address
    subnet_id  = yandex_vpc_subnet.websrver-1-subnet.id
  }
  target {
    ip_address = yandex_compute_instance.webserver2.network_interface.0.ip_address
    subnet_id  = yandex_vpc_subnet.websrver-2-subnet.id
  }
}

resource "yandex_compute_instance" "webserver1" {
  name        = "webserver-1"
  hostname    = "webserver-1"
  platform_id = var.platform
  zone        = var.zone_a

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = var.boot_image
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.websrver-1-subnet.id
    security_group_ids = [yandex_vpc_security_group.private-group.id, yandex_vpc_security_group.bastion-group.id]
  }

  metadata = {
    user-data = "${file("./metadata.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}

resource "yandex_compute_instance" "webserver2" {
  name        = "webserver-2"
  hostname    = "webserver-2"
  platform_id = var.platform
  zone        = var.zone_b

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = var.boot_image
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.websrver-2-subnet.id
    security_group_ids = [yandex_vpc_security_group.private-group.id,yandex_vpc_security_group.bastion-group.id]
  }

  metadata = {
    user-data = "${file("./metadata.txt")}"
  }

  scheduling_policy {
    preemptible = true
  }
}