variable "deployment_name" {}
variable "image" {}
variable "count" {}
variable "name" {}
variable "region" {}
variable "size" {}
variable "user" {}
# variable "user_data" {}
variable "private_networking" {}
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

variable "volume_ids" {
  type    = "list"
  default = [""]
}

variable "tag_ids" {
  type    = "list"
  default = [""]
}

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
  volume_ids         = ["${var.volume_ids}"]
  tags               = ["${var.tag_ids}"]

  provisioner "local-exec" {
    command = "echo 'Host ${var.name}-${count.index}\n    HostName ${self.ipv4_address}\n    User ${var.user}' | tee ${path.root}/${var.deployment_name}-${var.name}-${count.index}.config"
  }

  connection {
    type        = "ssh"
    host        = "${self.ipv4_address}"
    user        = "root"
  }

  provisioner "remote-exec" {
    inline = [
      <<EOF
      useradd -d /home/${var.user} -m ${var.user}
      echo '${var.user} ALL = (root) NOPASSWD:ALL' | tee /etc/sudoers.d/${var.user}
      "chmod 0440 /etc/sudoers.d/${var.user}
      mkdir /home/${var.user}/.ssh
      cp /root/.ssh/authorized_keys /home/${var.user}/.ssh/authorized_keys
      chown -R ${var.user}:${var.user} /home/${var.user}
      chmod 0700 /home/${var.user}/.ssh",
      chmod  600 /home/${var.user}/.ssh/authorized_keys
      EOF
      ,
    ]
  }
}

output "ip_public" {
  value = "${digitalocean_droplet.drop.*.ipv4_address}"
}

output "ip_private" {
  value = "${digitalocean_droplet.drop.*.ipv4_address_private}"
}

output "user" {
  value = "${var.user}"
}
