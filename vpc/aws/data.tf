data "aws_ami" "ubuntu" {
  most_recent = true

  filter = {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter = {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_ami" "nat" {
  most_recent = true

  filter = {
    name   = "name"
    values = ["amzn-ami-vpc-nat-*"]
  }

  filter = {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "ami_ubuntu_id" {
  value = "${data.aws_ami.ubuntu.id}"
}

output "ami_nat_id" {
  value = "${data.aws_ami.nat.id}"
}
