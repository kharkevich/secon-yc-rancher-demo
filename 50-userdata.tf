data "template_file" "userdata_server" {
  template = "${file("userdata/userdata_server.tpl")}"

  vars {
    admin_password        = "${var.admin_password}"
    cluster_name          = "${var.cluster_name}"
    server_url            = "${var.cloudflare_record}.${var.cloudflare_zone}"
    rancher_version       = "${var.rancher_version}"
  }
}

data "template_file" "userdata_agent_all" {
  template = "${file("userdata/userdata_agent.tpl")}"
  vars { 
    admin_password       = "${var.admin_password}"
    cluster_name         = "${var.cluster_name}"
    server_address       = "${yandex_compute_instance.rancherserver.network_interface.0.ip_address}"
    server_url           = "${var.cloudflare_record}.${var.cloudflare_zone}"
    role                 = "all-roles"
  }
}

data "template_file" "userdata_agent_controlplane" {
  template = "${file("userdata/userdata_agent.tpl")}"
  vars { 
    admin_password       = "${var.admin_password}"
    cluster_name         = "${var.cluster_name}"
    server_address       = "${yandex_compute_instance.rancherserver.network_interface.0.ip_address}"
    server_url           = "${var.cloudflare_record}.${var.cloudflare_zone}"
    role                 = "controlplane"
  }
}

data "template_file" "userdata_agent_etcd" {
  template = "${file("userdata/userdata_agent.tpl")}"
  vars { 
    admin_password       = "${var.admin_password}"
    cluster_name         = "${var.cluster_name}"
    server_address       = "${yandex_compute_instance.rancherserver.network_interface.0.ip_address}"
    server_url           = "${var.cloudflare_record}.${var.cloudflare_zone}"
    role                 = "etcd"
  }
}

data "template_file" "userdata_agent_worker" {
  template = "${file("userdata/userdata_agent.tpl")}"
  vars { 
    admin_password       = "${var.admin_password}"
    cluster_name         = "${var.cluster_name}"
    server_address       = "${yandex_compute_instance.rancherserver.network_interface.0.ip_address}"
    server_url           = "${var.cloudflare_record}.${var.cloudflare_zone}"
    role                 = "worker"
  }
}
