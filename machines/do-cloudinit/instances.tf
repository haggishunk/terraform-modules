variable "deployment_name" {}
variable "image" {}
variable "count" {}
variable "name" {}
variable "region" {}
variable "size" {}
variable "private_networking" {}
variable "user" {}
# variable "user_data" {}
variable "ssh_pri_file" {}

variable "ssh_ids" {
  type    = "list"
  default = [""]
}

variable "backups" {
  default = false
}

variable "monitoring" {
  default = false
}

variable "ipv6" {
  default = false
}

variable "resize_disk" {
  default = true
}

# variable "volume_ids" {
#   type    = "list"
#   default = [""]
# }

# variable "tag_ids" {
#   type    = "list"
#   default = [""]
# }

resource "digitalocean_droplet" "drop" {
  count              = "${var.count}"
  image              = "${var.image}"
  name               = "${var.name}-${count.index}"
  region             = "${var.region}"
  size               = "${var.size}"
  backups            = "${var.backups}"
  ipv6               = "${var.ipv6}"
  monitoring         = "${var.monitoring}"
  resize_disk        = "${var.resize_disk}"
  private_networking = "${var.private_networking}"
  # user_data          = "${var.user_data}"
  ssh_keys           = ["${var.ssh_ids}"]
  # volume_ids         = ["${var.volume_ids}"]
  # tags               = ["${var.tag_ids}"]

  user_data = <<EOF
    users:
    - name: ${var.user}
      groups: sudo
      shell: /bin/bash
      sudo: ['ALL=(ALL) NOPASSWD:ALL']
      ssh-authorized-keys:
        - ssh-rsa ${file(format("%s.pub", var.ssh_pri_file))}
    EOF

  provisioner "local-exec" {
    command = "echo 'Host ${var.name}-${count.index}\n    HostName ${self.ipv4_address}\n    User ${var.user}' | tee ${path.root}/${var.deployment_name}-${var.name}-${count.index}.config"
  }
}

output "ip_public" {
  value = "${digitalocean_droplet.drop.*.ipv4_address}"
}

output "ip_private" {
  value = "${var.private_networking && true ? join(",", digitalocean_droplet.drop.*.ipv4_address_private) : ""}"
}

output "user" {
  value = "${var.user}"
}
