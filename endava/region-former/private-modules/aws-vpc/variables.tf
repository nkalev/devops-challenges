variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  default     = ""
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "infra_public_subnets" {
  description = "A list of public subnets for shared infra"
  default     = []
}

variable "azs" {
  description = "A list of Availability zones in the region"
  default     = []
}

variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = false
}

variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = false
}

variable "map_public_ip_on_launch" {
  description = "should be false if you do not want to auto-assign public IP on launch"
  default     = true
}

variable "public_propagating_vgws" {
  description = "A list of VGWs the shared public route table should propagate."
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "infra_public_subnet_tags" {
  description = "Additional tags for the public subnets"
  default     = {}
}

