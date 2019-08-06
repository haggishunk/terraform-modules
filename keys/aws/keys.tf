variable "vpc_name" {}
variable "ssh_pub_file" {}

resource "aws_key_pair" "key" {
  key_name   = "terraform-${var.vpc_name}"
  public_key = "${file(var.ssh_pub_file)}"
}

output "ssh_key_name" {
  value = "${aws_key_pair.key.key_name}"
}
