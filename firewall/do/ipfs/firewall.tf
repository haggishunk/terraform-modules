variable "deployment_name" {}

variable "tag_ids" {
  type = "list"
}

variable "peer_ips" {
  default = ["0.0.0.0/0"]
}

resource "digitalocean_firewall" "ipfs" {
  name = "${var.deployment_name}-ipfs"

  tags = ["${var.tag_ids}"]

  inbound_rule = [
    {
      protocol         = "tcp"
      port_range       = "4001"
      source_addresses = ["${var.peer_ips}"]
    },
    {
      protocol         = "tcp"
      port_range       = "5001"
      source_addresses = ["${var.peer_ips}"]
    },
    {
      protocol         = "tcp"
      port_range       = "8080"
      source_addresses = ["${var.peer_ips}"]
    },
  ]
}

