variable "node_ips" { type = "list" }
variable "node_user" {}
variable "node_count" {}
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

data "template_file" "install" {
  template = "${file("${path.module}/install.sh")}"

  vars {
    user = "${var.node_user}"
  }
}
# use a normal connection if bastion_flag is false (default)
resource "null_resource" "node_config" {
  count = "${var.bastion_flag && "true" ? 0 : var.node_count }"

  connection {
    type        = "ssh"
    host        = "${element(var.node_ips, count.index)}"
    user        = "${var.node_user}"
  }

  triggers {
    "ip" = "${element(var.node_ips, count.index)}"
  }

  provisioner "remote-exec" {
    inline = ["${data.template_file.install.rendered}"]
  }
}

# use a bastion connection if bastion_flag is true
resource "null_resource" "node_config_bastion" {
  count = "${var.bastion_flag && "true" ? var.node_count : 0}"

  connection {
    type         = "ssh"
    host        = "${element(var.node_ips, count.index)}"
    user         = "${var.node_user}"
    bastion_host = "${var.bastion_ip}"
    bastion_user = "${var.bastion_user}"
  }

  triggers {
    "ip" = "${element(var.node_ips, count.index)}"
  }

  provisioner "remote-exec" {
    inline = ["${data.template_file.install.rendered}"]
  }
}
