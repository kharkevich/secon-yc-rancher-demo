resource "yandex_compute_instance" "rancheragent-all" {
  depends_on = ["yandex_compute_instance.rancherserver"]
  count                     = "${var.count_agent_all_nodes}"
  name                      = "${var.prefix}-rancheragent-${count.index}-all"
  description               = "k8s all-in-one node"
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
      name        = "k8s-all-root-${count.index}"
      description = "k8s aio disk ${count.index}"
      size        = "${var.instance_root_disk}"
    }
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.rancher_subnet.id}"
    nat       = true
  }
  metadata {
    user-data = "${data.template_file.userdata_agent_all.rendered}"
    ssh-keys  = "extor:${file("~/.ssh/id_rsa.pub")}"
  }
}
