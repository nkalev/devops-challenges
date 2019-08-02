variable "ssh_key_name" {default = "default-EC2-EU"}
variable "aws_region_name" { default = "eu-west-1" }
variable "our_zone_id" { default = "AWS_ZONE_ID" }
variable "our_domain" { default = "yourdomain.com" }

provider "aws" {
  region = "${var.aws_region_name}"
}

data "external" "showipaddr" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

module "nkalev_vpc" {
  source = "private-modules/aws-vpc"
  name   = "${format("nkalev_vpc_%s",var.aws_region_name)}"

  cidr = "10.240.0.0/16"

  azs = [
    "${format("%sa", var.aws_region_name)}",
    "${format("%sb", var.aws_region_name)}",
  ]

  infra_public_subnets = [
    "10.240.0.0/24",
    "10.240.1.0/24",
  ]

  tags {
    "environment" = "nkalev"
    "terraform"   = "true"
  }

  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_instance" "nagios" {
  count         = "1"
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.medium"
  associate_public_ip_address = true

  vpc_security_group_ids = ["${aws_security_group.k8s_sg.id}"]
  subnet_id = "${element(module.nkalev_vpc.infra_public_subnets,0)}"

  key_name = "${var.ssh_key_name}"

  tags {
    Name   = "k8s-worker"
    App    = "k8s"
    k8srole = "master"
  }
}

resource "aws_instance" "webserver-1a" {
  count         = "1"
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.medium"
  associate_public_ip_address = true

  vpc_security_group_ids = ["${aws_security_group.k8s_sg.id}"]
  subnet_id = "${element(module.nkalev_vpc.infra_public_subnets,0)}"

  key_name = "${var.ssh_key_name}"

  tags {
    Name   = "k8s-worker"
    App    = "k8s"
    k8srole = "worker-a"
  }
}

resource "aws_instance" "dbserver-1a" {
  count         = "1"
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.medium"
  associate_public_ip_address = true

  vpc_security_group_ids = ["${aws_security_group.k8s_sg.id}"]
  subnet_id = "${element(module.nkalev_vpc.infra_public_subnets,0)}"

  key_name = "${var.ssh_key_name}"

  tags {
    Name   = "k8s-worker"
    App    = "k8s"
    k8srole = "worker-a"
  }
}

resource "aws_instance" "lbserver-1a" {
  count         = "1"
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.medium"
  associate_public_ip_address = true

  vpc_security_group_ids = ["${aws_security_group.k8s_sg.id}"]
  subnet_id = "${element(module.nkalev_vpc.infra_public_subnets,0)}"

  key_name = "${var.ssh_key_name}"

  tags {
    Name   = "k8s-worker"
    App    = "k8s"
    k8srole = "worker-a"
  }
}

resource "aws_instance" "webserver-1b" {
  count         = "1"
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.medium"
  associate_public_ip_address = true

  vpc_security_group_ids = ["${aws_security_group.k8s_sg.id}"]
  subnet_id = "${element(module.nkalev_vpc.infra_public_subnets,1)}"

  key_name = "${var.ssh_key_name}"

  tags {
    Name   = "k8s-worker"
    App    = "k8s"
    k8srole = "worker-b"
  }
}

resource "aws_instance" "dbserver-1b" {
  count         = "1"
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.medium"
  associate_public_ip_address = true

  vpc_security_group_ids = ["${aws_security_group.k8s_sg.id}"]
  subnet_id = "${element(module.nkalev_vpc.infra_public_subnets,1)}"

  key_name = "${var.ssh_key_name}"

  tags {
    Name   = "k8s-worker"
    App    = "k8s"
    k8srole = "worker-b"
  }
}

resource "aws_instance" "lbserver-1b" {
  count         = "1"
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.medium"
  associate_public_ip_address = true

  vpc_security_group_ids = ["${aws_security_group.k8s_sg.id}"]
  subnet_id = "${element(module.nkalev_vpc.infra_public_subnets,1)}"

  key_name = "${var.ssh_key_name}"

  tags {
    Name   = "k8s-worker"
    App    = "k8s"
    k8srole = "worker-b"
  }
}

resource "aws_security_group" "k8s_sg" {
  vpc_id = "${module.nkalev_vpc.vpc_id}"
}

resource "aws_security_group_rule" "allow_all_egress" {
  type            = "egress"
  from_port	  = 0 
  to_port         = 65535
  protocol        = "all"
  cidr_blocks     = ["0.0.0.0/0"]
  description     = "Outbound access to ANY"

  security_group_id = "${aws_security_group.k8s_sg.id}"
}


resource "aws_security_group_rule" "allow_all_myip" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "all"
  cidr_blocks     = ["${data.external.showipaddr.result["ip"]}/32"]
  description     = "Management Ports for K8s Cluster"

  security_group_id = "${aws_security_group.k8s_sg.id}"
}

resource "aws_security_group_rule" "allow_SG_any" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "all"
  self            = true
  description     = "Any from SG for K8s Cluster"

  security_group_id = "${aws_security_group.k8s_sg.id}"
}

resource "aws_route53_record" "nkalev" {
  zone_id = "${var.our_zone_id}"
  name    = "nkalev.${var.our_domain}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.lbserver-1a.public_ip}","${aws_instance.lbserver-1b.public_ip}"]
}

resource "aws_route53_record" "nagios" {
  zone_id = "${var.our_zone_id}"
  name    = "nagios.${var.our_domain}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.nagios.public_ip}"]
}

output "nagios_ip" {
  value = "${aws_instance.nagios.public_ip}"
}
output "webserver_1a" {
  value = "${aws_instance.webserver-1a.public_ip}"
}
output "webserver_1b" {
  value = "${aws_instance.webserver-1b.public_ip}"
}
output "dbserver_1a" {
  value = "${aws_instance.dbserver-1a.public_ip}"
}
output "dbserver_1b" {
  value = "${aws_instance.dbserver-1b.public_ip}"
}
output "lbserver_1a" {
  value = "${aws_instance.lbserver-1a.public_ip}"
}
output "lbserver_1b" {
  value = "${aws_instance.lbserver-1b.public_ip}"
}
