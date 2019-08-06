variable "name" {}

resource "digitalocean_tag" "tag" {
  name = "${var.name}"
}

output "tag_id" {
  value = "${digitalocean_tag.tag.id}"
}

output "tag_name" {
  value = "${digitalocean_tag.tag.name}"
}
