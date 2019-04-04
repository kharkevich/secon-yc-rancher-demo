output "rancher-url" {
  value = "https://${var.cloudflare_record}.${var.cloudflare_zone}/"
}
