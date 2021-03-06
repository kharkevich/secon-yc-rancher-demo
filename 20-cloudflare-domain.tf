resource "cloudflare_record" "rancher_url" {
  depends_on = ["yandex_compute_instance.rancherserver"]
  domain  = "${var.cloudflare_zone}"
  name    = "${var.cloudflare_record}"
  value   = "${yandex_compute_instance.rancherserver.network_interface.0.nat_ip_address}"
  type    = "A"
  ttl     = "120"
  proxied = false
}
