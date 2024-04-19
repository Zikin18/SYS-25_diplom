resource "yandex_compute_snapshot_schedule" "snapshot-shedule" {
  name = "snapshot-shedule"

  schedule_policy {
    expression = "0 0 * * *"
  }

  snapshot_count = 7

  snapshot_spec {
      description = "Делает копию серверов каждый день"
  }

  disk_ids = [
    "${yandex_compute_instance.bastionhost.boot_disk.0.disk_id}", 
    "${yandex_compute_instance.webserver1.boot_disk.0.disk_id}", 
    "${yandex_compute_instance.webserver2.boot_disk.0.disk_id}", 
    "${yandex_compute_instance.zabbix.boot_disk.0.disk_id}", 
    "${yandex_compute_instance.elasticsearch.boot_disk.0.disk_id}", 
    "${yandex_compute_instance.kibana.boot_disk.0.disk_id}"
    ]
}