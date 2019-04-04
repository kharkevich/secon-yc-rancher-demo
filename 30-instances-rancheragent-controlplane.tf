resource "yandex_compute_instance" "rancheragent-controlplane" {
  count                     = "${var.count_agent_controlplane_nodes}"
  name                      = "${var.prefix}-rancheragent-${count.index}-controlplane"
  description               = "k8s controlplane node"
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 5
  }

  boot_disk {
    auto_delete = true

    initialize_params {
      image_id    = "${var.image_id}"
      name        = "k8s-controlplane-root-${count.index}"
      description = "k8s controlplane disk ${count.index}"
      size        = "${var.instance_root_disk}"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.rancher_subnet.id}"
    nat       = false
  }

  metadata {
    user-data = "${data.template_file.userdata_agent_controlplane.rendered}"
    ssh-keys  = "extor:${file("~/.ssh/id_rsa.pub")}"
  }
}
