resource "local_file" "ansible-inventory" {
  content  = <<-EOT
    [bastion]
    ${yandex_compute_instance.bastionhost.fqdn} public_ip=${yandex_compute_instance.bastionhost.network_interface.0.nat_ip_address} 

    [web]
    ${yandex_compute_instance.webserver1.fqdn} 
    ${yandex_compute_instance.webserver2.fqdn}

    [balancer]
    ${yandex_alb_load_balancer.load-balancer.listener.0.endpoint.0.address.0.external_ipv4_address.0.address}

    [zabbix]
    ${yandex_compute_instance.zabbix.fqdn} public_ip=${yandex_compute_instance.zabbix.network_interface.0.nat_ip_address} 

    [elastic]
    ${yandex_compute_instance.elasticsearch.fqdn}

    [kibana]
    ${yandex_compute_instance.kibana.fqdn} public_ip=${yandex_compute_instance.kibana.network_interface.0.nat_ip_address} 

    [web:vars]
    domain="graduate-work"
    
    [all:vars]
    ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="ssh -o StrictHostKeyChecking=no -p 22 -W %h:%p -q sa@${yandex_compute_instance.bastionhost.network_interface.0.nat_ip_address}"'
    EOT
  filename = "../Ansible/inventory.ini"
}