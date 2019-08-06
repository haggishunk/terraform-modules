variable "node_ip" {}
variable "node_user" {}
variable "ssh_pri_file" {}

variable "bastion_flag" {
  default = "false"
}

variable "bastion_user" {
  default = ""
}

variable "bastion_ip" {
  default = ""
}

# use a normal connection if bastion_flag is false (default)
resource "null_resource" "node_config" {
  count = "${var.bastion_flag == "true" ? 0 : 1}"

  connection {
    type        = "ssh"
    host        = "${var.node_ip}"
    user        = "${var.node_user}"
  }

  triggers {
    "ip" = "${var.node_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "curl https://releases.rancher.com/install-docker/17.03.sh | sh",
      "sudo usermod -aG docker ${var.node_user}",
    ]
  }
}

# use a bastion connection if bastion_flag is true
resource "null_resource" "node_config_bastion" {
  count = "${var.bastion_flag == "true" ? 1 : 0}"

  connection {
    type         = "ssh"
    host         = "${var.node_ip}"
    user         = "${var.node_user}"
    bastion_host = "${var.bastion_ip}"
    bastion_user = "${var.bastion_user}"
  }

  triggers {
    "ip" = "${var.node_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "curl https://releases.rancher.com/install-docker/17.03.sh | sh",
      "sudo usermod -aG docker ${var.node_user}",
    ]
  }
}
