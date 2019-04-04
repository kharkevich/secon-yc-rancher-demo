resource "yandex_vpc_network" "rancher_network" {
  name        = "rancher-network"
  description = "Network for k8s"
}

resource "yandex_vpc_subnet" "rancher_subnet" {
  name           = "rancher-subnet"
  description    = "Subnet for k8s"
  zone           = "${var.yandex_zone}"
  network_id     = "${yandex_vpc_network.rancher_network.id}"
  v4_cidr_blocks = "${var.cluster_subnet}"
}
