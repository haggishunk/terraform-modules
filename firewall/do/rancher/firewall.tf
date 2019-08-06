variable "deployment_name" {}
variable "ipsec_tag_ids" {
  type = "list"
}

variable "ha_tag_ids" {
  type = "list"
}
variable "web_tag_ids" {
  type = "list"
}

variable "ipsec_ips" {
  default = ["0.0.0.0/0"]
}

variable "ha_ips" {
  default = ["0.0.0.0/0"]
}
variable "web_ips" {
  default = ["0.0.0.0/0"]
}

resource "digitalocean_firewall" "ipsec" {
  name = "${var.deployment_name}-ipsec"

  tags = ["${var.ipsec_tag_ids}"]

  inbound_rule = [
    {
      protocol         = "udp"
      port_range       = "500"
      source_addresses = ["${var.ipsec_ips}"]
    },
    {
      protocol         = "udp"
      port_range       = "4500"
      source_addresses = ["${var.ipsec_ips}"]
    },
  ]
}

resource "digitalocean_firewall" "ha" {
  name = "${var.deployment_name}-ha"

  tags = ["${var.ha_tag_ids}"]

  inbound_rule = [
    {
      protocol         = "tcp"
      port_range       = "8080"
      source_addresses = ["${var.ha_ips}"]
    },
    {
      protocol         = "tcp"
      port_range       = "9345"
      source_addresses = ["${var.ha_ips}"]
    },
  ]
}

resource "digitalocean_firewall" "web" {
  name = "${var.deployment_name}-web"

  tags = ["${var.web_tag_ids}"]

  inbound_rule = [
    {
      protocol         = "tcp"
      port_range       = "80"
      source_addresses = ["${var.web_ips}"]
    },
    {
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = ["${var.web_ips}"]
    },
  ]

}
