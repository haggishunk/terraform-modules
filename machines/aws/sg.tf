resource "aws_security_group" "web-in" {
  name        = "web-in-${var.spawn_name}"
  description = "lets in http(s) from anywhere"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "openvpn" {
  name   = "openvpn-${var.spawn_name}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ipsec" {
  name = "ipsec-${var.spawn_name}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 500
    to_port = 500
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 4500
    to_port = 4500
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "jumpbox_sg_ids" {
  value = [
    "${aws_security_group.openvpn.id}", 
    "${aws_security_group.web-in.id}",
    "${aws_security_group.ipsec.id}",
  ]
}

output "nat_sg_ids" {
  value = [
    "${aws_security_group.openvpn.id}", 
    "${aws_security_group.web-in.id}",
    "${aws_security_group.ipsec.id}",
  ]
}
