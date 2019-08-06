variable "config_name" {}
variable "ui_domain" {}

variable "node_ips" {
  type = "list"
}

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

variable "pre-sleep" {
  default = "20"
}

data "template_file" "start-rancher" {
  template = "${path.module}/start-rancher.sh"

  vars {
    pre-sleep = "20"
    name      = "${var.config_name}"
    domain    = "${var.ui_domain}"
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

  provisioner "file" {
    source      = "${path.root}/certs/seashanty.enjoyingmy.coffee.crt"
    destination = "$HOME/certs/seashanty.enjoyingmy.coffee.crt"
  }

  provisioner "file" {
    source      = "${path.root}/certs/seashanty.enjoyingmy.coffee.key"
    destination = "$HOME/certs/seashanty.enjoyingmy.coffee.key"
  }

  provisioner "remote-exec" {
    inline = ["${data.template_file.start-rancher.rendered}"]
  }
}

# use a bastion connection if bastion_flag is true
resource "null_resource" "node_config_bastion" {
  count = "${var.bastion_flag && "true" ? var.node_count : 0}"

  connection {
    type         = "ssh"
    host         = "${element(var.node_ips, count.index)}"
    user         = "${var.node_user}"
    bastion_host = "${var.bastion_ip}"
    bastion_user = "${var.bastion_user}"
  }

  triggers {
    "ip" = "${element(var.node_ips, count.index)}"
  }

  provisioner "file" {
    source      = "${path.root}/certs/seashanty.enjoyingmy.coffee.crt"
    destination = "$HOME/certs/seashanty.enjoyingmy.coffee.crt"
  }

  provisioner "file" {
    source      = "${path.root}/certs/seashanty.enjoyingmy.coffee.key"
    destination = "$HOME/certs/seashanty.enjoyingmy.coffee.key"
  }

  provisioner "remote-exec" {
    inline = ["${data.template_file.start-rancher.rendered}"]
  }
}
