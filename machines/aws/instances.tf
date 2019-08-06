variable "deployment_name" {}
variable "instance_name" {}
variable "instance_count" {}
variable "instance_type" {}
variable "ami_id" {}
variable "ami_user" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "public_ip_flag" {}
variable "sg_id" {}
variable "jumpbox_ip" {}
variable "jumpbox_user" {}
variable "ssh_key_name" {}
variable "ssh_pri_file" {}

resource "aws_instance" "worker_node" {
  ami                         = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  count                       = "${var.instance_count}"
  subnet_id                   = "${var.subnet_id}"
  associate_public_ip_address = "${var.public_ip_flag}"
  key_name                    = "${var.ssh_key_name}"

  tags {
    Name       = "${var.instance_name}-${count.index}"
    Deployment = "${var.deployment_name}"
  }

  vpc_security_group_ids = [
    "${var.sg_id}",
    "${aws_security_group.web-in.id}",
  ]

  provisioner "local-exec" {
    command = "echo '\nHost ${var.instance_name}-${count.index}\n    HostName ${self.private_ip}\n    User ${var.ami_user}\n    ProxyCommand ssh -q -W %h:%p jumpbox-${var.instance_name} ' | tee ${path.root}/${var.deployment_name}-${var.instance_name}-${count.index}.config"
  }
}

output "public_ips" {
  value = "${aws_instance.worker_node.*.public_ip}"
}

output "private_ips" {
  value = "${aws_instance.worker_node.*.private_ip}"
}
