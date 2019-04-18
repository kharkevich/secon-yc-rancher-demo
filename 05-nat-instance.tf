# resource "yandex_compute_instance" "nat-gateway" {
#   count                     = "1"
#   name                      = "${var.prefix}-nat-gateway"
#   description               = "shared nat gateway node"
#   allow_stopping_for_update = true
#   resources {
#     cores         = 1
#     memory        = 1
#     core_fraction = 5
#   }
#   boot_disk {
#     auto_delete = true

#     initialize_params {
#       image_id    = "${var.image_id}"
#       name        = "nat-gateway-root"
#       description = "rancher disk"
#       size        = "${var.instance_root_disk}"
#     }
#   }
#   network_interface {
#     subnet_id = "${yandex_vpc_subnet.rancher_subnet.id}"
#     nat       = true
#   }
#   metadata {
#     user-data = "${data.template_file.userdata_nat.rendered}"
#     ssh-keys  = "extor:${file("~/.ssh/id_rsa.pub")}"
#   }
# }
