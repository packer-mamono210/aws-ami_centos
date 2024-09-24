packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

variable "ami_name" {
  type    = string
  default = ""
}

variable "aws_profile" {
  type    = string
  default = ""
}

variable "aws_region" {
  type    = string
  default = ""
}

variable "tag_name" {
  type    = string
  default = ""
}

source "amazon-ebs" "centos" {
  ami_name      = "${var.ami_name}"
  instance_type = "t2.medium"
  profile       = "${var.aws_profile}"
  region        = "${var.aws_region}"
  source_ami    = "ami-0a0aa54caf414e700"
  ssh_username  = "ec2-user"
  tags = {
   Name        = "${var.tag_name}"
  }
}

build {
  name = "cs9-build"
  sources = [
    "source.amazon-ebs.centos"
  ]

  provisioner "shell" {
    inline = ["sudo dnf -y update"]
  }
}
