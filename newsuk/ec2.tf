# Part 2
# https://www.terraform.io/docs/providers/aws/r/security_group.html
# https://www.terraform.io/docs/providers/aws/r/instance.html in order to find
# configuration that satisfies requirements
# data "aws_ami" "ubuntu" {
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   owners = ["099720109477"] # Canonical
# }
# resource "aws_instance" "private_server" {
#   ami           = "${data.aws_ami.ubuntu.id}"
#   instance_type = "t2.micro"
#   tags = {
#     Name = "HelloWorld"
#   }
# }
