resource "aws_vpc" "vpc" {
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  enable_dns_support = var.vpc_enable_dns_support
  cidr_block = var.vpc_cidr_block


  tags = merge({
    Name = local.vpc_name
  }, local.common_tags)

}
