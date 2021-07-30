resource "aws_subnet" "db" {
  count = local.num_availability_zones

  vpc_id = aws_vpc.vpc.id

  cidr_block = local.subnet_cidr_blocks.db[local.availability_zones[count.index]]
  availability_zone = local.availability_zones[count.index]


  tags = merge({
    Name = "${local.vpc_name}-db-${local.availability_zones[count.index]}"
    Tier = "db"
    AvailabilityZone = "ap-southeast-1a"
  }, local.common_tags)
}

