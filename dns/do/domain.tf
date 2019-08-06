variable "domain" {}
variable "subdomain" {}
variable "alias_ip" {}
variable "wildcard_flag" {}

variable "domain_ip" {
  default = ""
}

variable "domain_flag" {
  default = false
}

variable "ttl" {
  default = 600
}

# DO NOT USE IF YOU ALREADY HAVE A DOMAIN IN DIGITALOCEAN
# This sets up the base domain A record for your PaaS
# defaults to first node
resource "digitalocean_domain" "domain" {
  count = "${var.domain_flag == "true" ? 1 : 0}"

  name       = "${var.domain}"
  ip_address = "${var.domain_ip}"
}

# add an alias 'A' record
resource "digitalocean_record" "alias" {
  name   = "${var.subdomain}"
  type   = "A"
  domain = "${var.domain}"
  value  = "${var.alias_ip}"
  ttl    = 600
}

# add a wildcard CNAME record to support subdomain reverse proxying
resource "digitalocean_record" "wildcard" {
  count = "${var.wildcard_flag && "true" ? 1 : 0}"

  name   = "*.${var.subdomain}"
  type   = "CNAME"
  domain = "${var.domain}"
  value  = "${var.subdomain}.${var.domain}."
  ttl    = 600
}

output "alias_fqdn" {
  value = "${digitalocean_record.alias.fqdn}"
}

output "domain" {
  value = "${var.domain}"
}
