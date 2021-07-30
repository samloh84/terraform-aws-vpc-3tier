locals {
  security_group_traffic_rules = {
    web = {
      app = [
        "http",
        "https",
        "ssh",
        "rdp"]
      out_internet = [
        "http",
        "https"]
      self = [
        "all"]
    }
    bastion = {
      web = [
        "http",
        "https",
        "ssh",
        "rdp"]
      out_internet = [
        "http",
        "https"]
      self = [
        "all"]
    }

    app = {
      db = [
        "http",
        "https",
        "ssh",
        "rdp",
        "mysql",
        "mssql",
        "oracledb",
        "postgresql",
        "mongodb",
        "memcached",
        "redis"]
      out_internet = [
        "http",
        "https"]
      self = [
        "all"]
    }
    db = {
      self = [
        "all"]
    }

    management = {
      bastion = [
        "http",
        "https",
        "ssh",
        "rdp"]
    }

    in_internet = {
      web = [
        "http",
        "https"]
    }

  }

  security_group_sources = {
    self = {
      self = true
      cidr_blocks = null
      source_security_group_id = null
    }
    bastion = {
      source_security_group_id = aws_security_group.bastion.id
      self = null
      cidr_blocks = null
    }
    web = {
      source_security_group_id = aws_security_group.web.id
      self = null
      cidr_blocks = null
    }
    app = {
      source_security_group_id = aws_security_group.app.id
      self = null
      cidr_blocks = null
    }
    db = {
      source_security_group_id = aws_security_group.db.id
      self = null
      cidr_blocks = null
    }
    out_internet = {
      source_security_group_id = null
      self = null
      cidr_blocks = local.whitelist_outgoing_http_request_cidr_blocks
    }
    in_internet = {
      source_security_group_id = null
      self = null
      cidr_blocks = local.whitelist_incoming_http_request_cidr_blocks
    }
    management = {
      source_security_group_id = null
      self = null
      cidr_blocks = local.management_network_cidr_blocks
    }
  }


}

