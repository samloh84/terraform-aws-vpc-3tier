variable "num_availability_zones" {
  type = number
  default = "0"
}

locals {
  vpc_name = coalesce(var.vpc_name, var.project_name)


  tier_cidr_blocks = {
    web = cidrsubnet(var.vpc_cidr_block, 4, 0)
    app = cidrsubnet(var.vpc_cidr_block, 4, 1)
    db = cidrsubnet(var.vpc_cidr_block, 4, 2)
  }

  num_availability_zones = var.num_availability_zones > 0? min(var.num_availability_zones, length(data.aws_availability_zones.availability_zones.names)): length(data.aws_availability_zones.availability_zones.names)

  availability_zones = slice(data.aws_availability_zones.availability_zones.names, 0, local.num_availability_zones)



  subnet_cidr_blocks = {
    web = {
    for i in range(local.num_availability_zones): local.availability_zones[i]=>cidrsubnet(local.tier_cidr_blocks.web, 4, i)
    }
    app = {
    for i in range(local.num_availability_zones): local.availability_zones[i]=>cidrsubnet(local.tier_cidr_blocks.app, 4, i)
    }
    db = {
    for i in range(local.num_availability_zones): local.availability_zones[i]=>cidrsubnet(local.tier_cidr_blocks.db, 4, i)
    }
  }


  local_cidr = "${chomp(data.http.icanhazip.body)}/32"


  whitelist_incoming_http_request_cidr_blocks = coalescelist(var.whitelist_incoming_http_request_cidr_blocks, [
    "0.0.0.0/0"])
  whitelist_outgoing_http_request_cidr_blocks = coalescelist(var.whitelist_outgoing_http_request_cidr_blocks, [
    "0.0.0.0/0"])
  management_network_cidr_blocks = coalescelist(var.management_network_cidr_blocks, [
    local.local_cidr])



  common_tags = merge({
    Project = var.project_name
    Owner = var.owner
  }, var.tags)
}