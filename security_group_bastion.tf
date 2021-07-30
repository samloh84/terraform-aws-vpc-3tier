resource "aws_security_group" "bastion" {
  name = "${local.vpc_name}-bastion"
  description = "bastion Tier of VPC ${local.vpc_name}. This tier is public and contains services exposed to the Internet."
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name = "${local.vpc_name}-bastion"
    Tier = "bastion"
  }, local.common_tags)
}

locals {
  security_group_bastion_ingress_rules = {for tier, tier_traffic_rules in local.security_group_traffic_rules: tier=>lookup(tier_traffic_rules, "bastion", null) if lookup(tier_traffic_rules, "bastion", null)!=null}

  security_group_bastion_ingress_rules_list = flatten([for tier, services in local.security_group_bastion_ingress_rules: [for service in services:{
    from_port = lookup(lookup(local.service_port_numbers, service, {
    }), "from_port", service)
    to_port = lookup(lookup(local.service_port_numbers, service, {
    }), "to_port", service)
    protocol = lookup(lookup(local.service_port_numbers, service, {
    }), "protocol", "-1")
    cidr_blocks = lookup(local.security_group_sources[tier], "cidr_blocks", null)
    source_security_group_id = lookup(local.security_group_sources[tier], "source_security_group_id", null)
    self = lookup(local.security_group_sources[tier], "self", null)
    description = join(" ", [
      "Allow ingress",
      lookup(lookup(local.service_port_numbers, service, {
      }), "service_name", service),
      "traffic from ${tier} tier to bastion tier"])
  }]])

  security_group_bastion_egress_rules = local.security_group_traffic_rules.bastion

  security_group_bastion_egress_rules_list = flatten([for tier, services in local.security_group_bastion_egress_rules: [for service in services:{
    from_port = lookup(lookup(local.service_port_numbers, service, {
    }), "from_port", service)
    to_port = lookup(lookup(local.service_port_numbers, service, {
    }), "to_port", service)
    protocol = lookup(lookup(local.service_port_numbers, service, {
    }), "protocol", "-1")
    cidr_blocks = lookup(local.security_group_sources[tier], "cidr_blocks", null)
    source_security_group_id = lookup(local.security_group_sources[tier], "source_security_group_id", null)
    self = lookup(local.security_group_sources[tier], "self", null)
    description = join(" ", [
      "Allow egress",
      lookup(lookup(local.service_port_numbers, service, {
      }), "service_name", service),
      "traffic from bastion tier to ${tier} tier"])
  }]])
}


resource "aws_security_group_rule" "bastion_ingress" {
  count = length(local.security_group_bastion_ingress_rules_list)
  security_group_id = aws_security_group.bastion.id


  type = "ingress"
  protocol = lookup(local.security_group_bastion_ingress_rules_list[count.index], "protocol", null)
  from_port = lookup(local.security_group_bastion_ingress_rules_list[count.index], "from_port", null)
  to_port = lookup(local.security_group_bastion_ingress_rules_list[count.index], "to_port", null)
  cidr_blocks = lookup(local.security_group_bastion_ingress_rules_list[count.index], "cidr_blocks", null)
  source_security_group_id = lookup(local.security_group_bastion_ingress_rules_list[count.index], "source_security_group_id", null)
  description = lookup(local.security_group_bastion_ingress_rules_list[count.index], "description", null)
  self= lookup(local.security_group_bastion_ingress_rules_list[count.index], "self", null)
}

resource "aws_security_group_rule" "bastion_egress" {
  count = length(local.security_group_bastion_egress_rules_list)
  security_group_id = aws_security_group.bastion.id


  type = "egress"
  protocol = lookup(local.security_group_bastion_egress_rules_list[count.index], "protocol", null)
  from_port = lookup(local.security_group_bastion_egress_rules_list[count.index], "from_port", null)
  to_port = lookup(local.security_group_bastion_egress_rules_list[count.index], "to_port", null)
  cidr_blocks = lookup(local.security_group_bastion_egress_rules_list[count.index], "cidr_blocks", null)
  source_security_group_id = lookup(local.security_group_bastion_egress_rules_list[count.index], "source_security_group_id", null)
  description = lookup(local.security_group_bastion_egress_rules_list[count.index], "description", null)
  self= lookup(local.security_group_bastion_egress_rules_list[count.index], "self", null)
}
