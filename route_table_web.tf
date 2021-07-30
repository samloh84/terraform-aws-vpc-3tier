resource "aws_route_table" "web" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }


  tags = merge({
    Name = "${local.vpc_name}-web"
    Tier = "web"
  }, local.common_tags)
}

