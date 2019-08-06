variable "deployment_name" {}

variable "update_tag_ids" {
  type = "list"
}

variable "ssh_tag_ids" {
  type = "list"
}

variable "ssh_admin_ips" {
  type = "list"
}

resource "digitalocean_firewall" "ssh" {
  name = "${var.deployment_name}-ssh"

  tags = ["${var.ssh_tag_ids}"]

  inbound_rule = [
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["${var.ssh_admin_ips}"]
    },
  ]
}

resource "digitalocean_firewall" "update" {
  name = "${var.deployment_name}-update"

  tags = ["${var.update_tag_ids}"]

  outbound_rule = [
    {
      protocol   = "tcp"
      port_range = "1-65535"

      destination_addresses = ["0.0.0.0/0"]
    },
    {
      protocol   = "udp"
      port_range = "1-65535"

      destination_addresses = ["0.0.0.0/0"]
    },
    {
      protocol   = "icmp"
      port_range = "1-65535"

      destination_addresses = ["0.0.0.0/0"]
    },
  ]
}
