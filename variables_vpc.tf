variable "vpc_cidr_block" {
  type = string
  default = "192.168.0.0/16"
}

variable "vpc_enable_dns_support" {
  default = true
}
variable "vpc_enable_dns_hostnames" {
  default = true
}
