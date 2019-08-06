variable "name" {}
variable "owner_id" {}
variable "admin_user" {}

data "aws_ami" "image" {
    most_recent                 = true

    filter = {
        name                    = "name"
        values                  = ["${var.name}"]
    }

    filter = {
        name                    = "virtualization-type"
        values                  = ["hvm"]
    }

    filter = {
        name                    = "is-public"
        values                  = ["true"]
    }

    owners                      = ["${var.owner_id}"]
}


output "ami_id" {
  value = "${data.aws_ami.image.id}"
}

output "ami_user" {
  value = "${var.admin_user}"
}
