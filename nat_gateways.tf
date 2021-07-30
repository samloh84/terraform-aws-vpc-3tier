resource "aws_eip" "nat_gateway" {
  count = local.num_availability_zones
  vpc = true

  tags = merge({
    Name = "${local.vpc_name}-nat-gateway-${local.availability_zones[count.index]}"
    Tier = "web"
    AvailabilityZone = local.availability_zones[count.index]
  }, local.common_tags)
}

resource "aws_nat_gateway" "nat_gateways" {
  count = local.num_availability_zones

  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id = aws_subnet.web[count.index].id
  depends_on = [
    aws_internet_gateway.internet_gateway]

  tags = merge({
    Name = "${local.vpc_name}-nat-gateway-${local.availability_zones[count.index]}"
    Tier = "web"
    AvailabilityZone = local.availability_zones[count.index]
  }, local.common_tags)
}
