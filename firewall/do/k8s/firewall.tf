variable "deployment_name" {}

variable "master_tag_ids" {
  type = "list"
}

variable "worker_tag_ids" {
  type = "list"
}

variable "source_ips" {
  default = ["0.0.0.0/0"]
}

resource "digitalocean_firewall" "master" {
  name = "${var.deployment_name}-kube-master"

  tags = ["${var.master_tag_ids}"]

  inbound_rule = [
    {
      protocol         = "tcp"
      port_range       = "6443"
      source_addresses = ["${var.source_ips}"]
    },
    {
      protocol         = "tcp"
      port_range       = "2379-2380"
      source_addresses = ["${var.source_ips}"]
    },
    {
      protocol         = "tcp"
      port_range       = "10250-10255"
      source_addresses = ["${var.source_ips}"]
    },
  ]
}

resource "digitalocean_firewall" "worker" {
  name = "${var.deployment_name}-kube-worker"

  tags = ["${var.worker_tag_ids}"]

  inbound_rule = [
    {
      protocol         = "tcp"
      port_range       = "10250"
      source_addresses = ["${var.source_ips}"]
    },
    {
      protocol         = "tcp"
      port_range       = "10255"
      source_addresses = ["${var.source_ips}"]
    },
    {
      protocol         = "tcp"
      port_range       = "30000-32767"
      source_addresses = ["0.0.0.0/0"]
    },
  ]
}
