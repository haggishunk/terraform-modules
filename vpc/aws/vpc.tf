#--------VPC-----------------

resource "aws_vpc" "VPC-terraform" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name     = "VPC-${var.vpc_name}"
    Deployer = "terraform"
  }
}

# -------SUBNET--------------
resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.VPC-terraform.id}"
  cidr_block = "10.0.0.0/24"

  tags {
    Name     = "public-${var.vpc_name}"
    Deployer = "terraform"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = "${aws_vpc.VPC-terraform.id}"
  cidr_block = "10.0.6.0/24"

  tags {
    Name     = "private-${var.vpc_name}"
    Deployer = "terraform"
  }
}

# -------GATEWAY-------------
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.VPC-terraform.id}"

  tags {
    Name     = "igw-${var.vpc_name}"
    Deployer = "terraform"
  }
}

# -------ROUTES--------------
resource "aws_route_table" "to-igw" {
  vpc_id = "${aws_vpc.VPC-terraform.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name     = "to-igw-${var.vpc_name}"
    Deployer = "terraform"
  }
}

resource "aws_route_table_association" "public-to-igw" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.to-igw.id}"
}

resource "aws_route_table" "to-nat" {
  vpc_id = "${aws_vpc.VPC-terraform.id}"

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }

  tags {
    Name     = "to-nat-${var.vpc_name}"
    Deployer = "terraform"
  }
}

resource "aws_route_table_association" "private-to-nat" {
  subnet_id      = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.to-nat.id}"
}

# designate NAT route as default "main" route table
# this only comes into play when creating a new subnet
# inside the vpc
resource "aws_main_route_table_association" "main" {
  vpc_id         = "${aws_vpc.VPC-terraform.id}"
  route_table_id = "${aws_route_table.to-nat.id}"
}

# -------SECURITY GROUP------
resource "aws_security_group" "in-vpc" {
  name        = "in-vpc-${var.vpc_name}"
  description = "keep it in the family"
  vpc_id      = "${aws_vpc.VPC-terraform.id}"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh" {
  name        = "ssh-${var.vpc_name}"
  description = "allow ssh access from my IP"
  vpc_id      = "${aws_vpc.VPC-terraform.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip_cidr}"]
  }
}

output "vpc_id" {
  value = "${aws_vpc.VPC-terraform.id}"
}

output "subnet_private_id" {
  value = "${aws_subnet.private.id}"
}

output "subnet_public_id" {
  value = "${aws_subnet.public.id}"
}

output "sg_in-vpc_id" {
  value = "${aws_security_group.in-vpc.id}"
}
