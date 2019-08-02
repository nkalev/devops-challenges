resource "aws_vpc" "mod" {
  cidr_block           = "${var.cidr}"
  instance_tenancy     = "${var.instance_tenancy}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags                 = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

resource "aws_internet_gateway" "mod" {
  vpc_id = "${aws_vpc.mod.id}"
  tags   = "${merge(var.tags, map("Name", format("%s-igw", var.name)))}"
}

resource "aws_route_table" "public" {
  vpc_id           = "${aws_vpc.mod.id}"
  propagating_vgws = ["${var.public_propagating_vgws}"]
  tags             = "${merge(var.tags, map("Name", "vpc-rt-public"))}"
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.mod.id}"
}

resource "aws_subnet" "infra_public" {
  vpc_id                  = "${aws_vpc.mod.id}"
  cidr_block              = "${var.infra_public_subnets[count.index]}"
  availability_zone       = "${element(var.azs, count.index)}"
  count                   = "${length(var.infra_public_subnets)}"
  tags                    = "${merge(var.tags, var.infra_public_subnet_tags, map("Name", format("infra-public-%s", element(var.azs, count.index))))}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
}

resource "aws_route_table_association" "infra_public" {
  count          = "${length(var.infra_public_subnets)}"
  subnet_id      = "${element(aws_subnet.infra_public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

