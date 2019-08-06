resource "aws_instance" "jumpbox" {
  ami           = "${var.jumpbox_ami_id}"
  instance_type = "t2.micro"
  depends_on    = ["aws_internet_gateway.igw"]

  subnet_id = "${aws_subnet.public.id}"

  vpc_security_group_ids = [
    "${aws_security_group.in-vpc.id}",
    "${aws_security_group.ssh.id}",
    "${var.jumpbox_sg_ids}",
  ]

  associate_public_ip_address = true
  key_name                    = "${var.ssh_key_name}"

  tags {
    Name     = "jumpbox-${var.vpc_name}"
    Deployer = "terraform"
  }

  provisioner "local-exec" {
    command = "echo '\nHost jumpbox-${var.vpc_name}\n    HostName ${self.public_ip}\n    User ${var.jumpbox_ami_user}' | tee -a ${path.root}/${var.vpc_name}-jumpbox.config"
  }
}

resource "aws_instance" "nat" {
  ami           = "${data.aws_ami.nat.id}"
  instance_type = "t2.micro"

  subnet_id                   = "${aws_subnet.public.id}"
  vpc_security_group_ids      = [
    "${aws_security_group.in-vpc.id}",
    "${var.nat_sg_ids}",
  ]
  associate_public_ip_address = true
  key_name                    = "${var.ssh_key_name}"
  source_dest_check           = false

  tags {
    Name     = "nat-${var.vpc_name}"
    Deployer = "terraform"
  }

  provisioner "local-exec" {
    command = "echo '\nHost nat-${var.vpc_name}\n    HostName ${self.private_ip}\n    User ec2-user\n    ProxyCommand ssh -q -W %h:%p jumpbox-${var.vpc_name}' | tee -a ${path.root}/${var.vpc_name}-vpc.config"
  }
}

output "nat_endpoint" {
  value = "${aws_instance.nat.public_ip}"
}

output "nat_user" {
  value = "ec2-user"
}

output "jumpbox_ip" {
  value = "${aws_instance.jumpbox.public_ip}"
}

output "jumpbox_user" {
  value = "${var.jumpbox_ami_user}"
}
