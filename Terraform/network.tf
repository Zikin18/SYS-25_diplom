resource "yandex_vpc_network" "main-network" {
  name        = "main-network"
}

resource "yandex_vpc_gateway" "gateway" {
  name = "gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "routetable" {
  network_id = yandex_vpc_network.main-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.gateway.id
  }
}

resource "yandex_vpc_subnet" "websrver-1-subnet" {
  name           = "websrver-1-subnet"
  zone           = var.zone_a
  network_id     = yandex_vpc_network.main-network.id
  v4_cidr_blocks = ["10.0.1.0/28"]
  route_table_id = yandex_vpc_route_table.routetable.id
}

resource "yandex_vpc_subnet" "websrver-2-subnet" {
  name           = "websrver-2-subnet"
  zone           = var.zone_b
  network_id     = yandex_vpc_network.main-network.id
  v4_cidr_blocks = ["10.0.2.0/28"]
  route_table_id = yandex_vpc_route_table.routetable.id
}

resource "yandex_vpc_subnet" "public-subnet" {
  name           = "public-subnet"
  zone           = var.zone_d
  network_id     = yandex_vpc_network.main-network.id
  v4_cidr_blocks = ["10.0.3.0/28"]
}

resource "yandex_vpc_subnet" "private-subnet" {
  name           = "private-subnet"
  zone           = var.zone_a
  network_id     = yandex_vpc_network.main-network.id
  v4_cidr_blocks = ["10.0.4.0/28"]
  route_table_id = yandex_vpc_route_table.routetable.id
}

resource "yandex_alb_backend_group" "backend-group" {
  name = "backend-group"

  http_backend {
    name             = "backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.webservers-target-group.id]

    load_balancing_config {
      panic_threshold = 90
    }

    healthcheck {
      timeout             = "10s"
      interval            = "2s"
      healthy_threshold   = 10
      unhealthy_threshold = 15
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "http-router" {
  name = "http-router"
}

resource "yandex_alb_virtual_host" "virtual-host" {
  name           = "virtual-host"
  http_router_id = yandex_alb_http_router.http-router.id
  route {
    name = "root-path"
    http_route {
      http_match {
        path {
          prefix = "/"
        }
      }
      http_route_action {
        backend_group_id = yandex_alb_backend_group.backend-group.id
        timeout          = "3s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "load-balancer" {
  name               = "load-balancer"
  network_id         = yandex_vpc_network.main-network.id
  security_group_ids = [yandex_vpc_security_group.public-load-balancer-group.id]

  allocation_policy {
    location {
      zone_id   = var.zone_a
      subnet_id = yandex_vpc_subnet.private-subnet.id
    }
  }

  listener {
    name = "listener"

    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }

    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router.id
      }
    }
  }
}