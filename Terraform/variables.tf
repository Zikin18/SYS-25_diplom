variable "zone_a" {
    type    = string
    default = "ru-central1-a"
}
variable "zone_b" {
    type    = string
    default = "ru-central1-b"
}
variable "zone_d" {
    type    = string
    default = "ru-central1-d"
}

variable "boot_image"{
    type    = string
    default = "fd833v6c5tb0udvk4jo6"
}

variable "platform" {
    type    = string
    default = "standard-v2"
}

locals {
  zone_names = [var.zone_a, var.zone_b]
}

variable "y_token" {
    type    = string
    default = ""
}

variable "y_cloud" {
    type    = string
    default = ""
}

variable "y_folder" {
    type    = string
    default = ""
}

variable "y_sa-admin" {
    type    = string
    default = ""
}