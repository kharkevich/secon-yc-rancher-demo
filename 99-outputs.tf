output "rancher-url" {
  depends_on = ["yandex_compute_instance.rancherserver"]
  value = "https://${var.cloudflare_record}.${var.cloudflare_zone}/"
}
