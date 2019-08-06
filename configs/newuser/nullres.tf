variable "new_user" {}
variable "node_ips" { type = "list" }
variable "node_ids" { type = "list" }
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

data "template_file" "newuser" {
  template = "${file("${path.module}/newuser-template.sh")}"

  vars {
    user = "${var.new_user}"
  }
}

# use a normal connection if bastion_flag is false (default)
resource "null_resource" "node_config" {
  count = "${var.bastion_flag && false ? var.node_count : 0}"

  connection {
    type        = "ssh"
    host        = "${element(var.node_ips, count.index)}"
    user        = "${var.node_user}"
  }

  triggers {
    "ip" = ["${var.node_ids}"]
  }

  provisioner "remote-exec" {
    inline = ["${data.template_file.newuser.rendered}"]
  }
}

# use a bastion connection if bastion_flag is true
resource "null_resource" "node_config_bastion" { 
  count = "${var.bastion_flag && true ? var.node_count : 0}"

  connection {
    type         = "ssh"
    host        = "${element(var.node_ips, count.index)}"
    user         = "${var.node_user}"
    bastion_host = "${var.bastion_ip}"
    bastion_user = "${var.bastion_user}"
  }

  triggers {
    "ip" = ["${var.node_ids}"]
  }

  provisioner "remote-exec" {
    inline = ["${data.template_file.newuser.rendered}"]
  }
}
