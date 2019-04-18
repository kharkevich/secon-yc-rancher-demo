variable "yandex_token" {
  default = "xxx"
}

variable "yandex_cloud_id" {
  default = "xxx"
}

variable "yandex_folder_id" {
  default = "xxx"
}

variable "yandex_zone" {
  default = "xxx"
}

variable "cloudflare_email" {
  default = "noreply@example.com"
}

variable "cloudflare_token" {
  default = "xxx"
}

variable "cloudflare_zone" {
  default = "example.com"
}

variable "cloudflare_record" {
  default = "rancher.secon"
}

variable "instance_root_disk" {
  default = "20"
}

variable "prefix" {
  default = "secon2019"
}

variable "rancher_version" {
  default = "latest"
}

variable "count_rancher_node" {
  default = "1"
}

variable "count_agent_all_nodes" {
  default = "3"
}

variable "count_agent_etcd_nodes" {
  default = "0"
}

variable "count_agent_controlplane_nodes" {
  default = "0"
}

variable "count_agent_worker_nodes" {
  default = "0"
}

variable "admin_password" {
  default = "admin!@#$"
}

variable "cluster_name" {
  default = "demo"
}

variable "cluster_subnet" {
  default = ["10.0.0.0/24"]
}

variable "image_id" {
  description = "Ubuntu 18.04 LTS"
  default     = "fd83i5r5g44fjkdpuuva"
}
