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
  source_ami_filter {
    filters = {
      name                = "CentOS-7-2111-20220825_1.x86_64-d9a3032a-921c-4c6d-b150-bde168105e42"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["aws-marketplace"]
  }
  ssh_username  = "centos"
  tags = {
    Name        = "${var.tag_name}"
  }
}

build {
  name = "centos7-build"
  sources = [
    "source.amazon-ebs.centos"
  ]

  provisioner "shell" {
    inline = ["sudo echo root | sudo passwd --stdin root"]
  }

  provisioner "shell" {
    inline = ["sudo yum -y update"]
  }
}
