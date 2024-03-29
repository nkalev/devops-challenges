output "infra_public_subnets" {
  value = ["${aws_subnet.infra_public.*.id}"]
}

output "vpc_id" {
  value = "${aws_vpc.mod.id}"
}

output "vpc_cidr" {
  value = "${aws_vpc.mod.cidr_block}"
}

output "public_route_table_ids" {
  value = ["${aws_route_table.public.*.id}"]
}

output "default_security_group_id" {
  value = "${aws_vpc.mod.default_security_group_id}"
}

output "igw_id" {
  value = "${aws_internet_gateway.mod.id}"
}

