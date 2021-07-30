resource "aws_route_table" "app" {
  count = local.num_availability_zones
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateways[count.index].id
  }

  tags = merge({
    Name = "${local.vpc_name}-app-${local.availability_zones[count.index]}"
    Tier = "app"
    AvailabilityZone = local.availability_zones[count.index]
  }, local.common_tags)
}
