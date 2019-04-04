resource "yandex_compute_instance" "rancherserver" {
  count                     = "1"
  name                      = "${var.prefix}-rancherserver"
  description               = "rancher server node"
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
      name        = "rancherserver-root"
      description = "rancher disk"
      size        = "${var.instance_root_disk}"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.rancher_subnet.id}"
    nat       = true
  }

  metadata {
    user-data = "${data.template_file.userdata_server.rendered}"
    ssh-keys  = "extor:${file("~/.ssh/id_rsa.pub")}"
  }
}
