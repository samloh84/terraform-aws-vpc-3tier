output "vpc_name" {
  value = local.vpc_name
}


output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_ids" {
  value = {
    web = {
    for subnet in aws_subnet.web: subnet.availability_zone => subnet.id
    }
    app = {
    for subnet in aws_subnet.app: subnet.availability_zone => subnet.id
    }
    db = {
    for subnet in aws_subnet.db: subnet.availability_zone => subnet.id
    }
  }
}

output "subnet_id_lists" {
  value = {
    web = aws_subnet.web.*.id
    app = aws_subnet.app.*.id
    db = aws_subnet.db.*.id
  }
}


output "security_group_ids" {
  value = {
    bastion = aws_security_group.bastion.id
    web = aws_security_group.web.id
    app = aws_security_group.app.id
    db = aws_security_group.db.id
  }
}

output "network_acl_ids" {
  value = {
    web = aws_network_acl.web.id
    app = aws_network_acl.app.id
    db = aws_network_acl.db.id
  }
}

