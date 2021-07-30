resource "aws_internet_gateway" "internet_gateway" {

  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name = "${local.vpc_name}-internet-gateway"
  }, local.common_tags)
}