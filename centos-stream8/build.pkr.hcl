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
  instance_type = "t2.micro"
  profile       = "${var.aws_profile}"
  region        = "${var.aws_region}"
  source_ami    = "ami-0b0e466c73417482d"
  ssh_username  = "centos"
  tags = {
    Name        = "${var.tag_name}"
  }
}

build {
  name = "cs8-build"
  sources = [
    "source.amazon-ebs.centos"
  ]

  provisioner "shell" {
    inline = ["sudo echo root | sudo passwd --stdin root"]
  }

  provisioner "shell" {
    inline = ["sudo dnf -y update"]
  }

  provisioner "shell" {
    inline = ["sudo sed -i -e \"s/ssh_genkeytypes:  ~/ssh_genkeytypes: ['rsa', 'ecdsa', 'ed25519']/\" /etc/cloud/cloud.cfg"]
  }
}
