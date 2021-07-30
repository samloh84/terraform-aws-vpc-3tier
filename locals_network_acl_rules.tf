locals {

  network_acl_traffic_rules = {
    web = {
      app = [
        "http",
        "https",
        "ssh",
        "rdp",
        "ephemeral"]
      out_internet = [
        "http",
        "https"]
      management = [
        "ephemeral"]
      in_internet = [
        "ephemeral"]
      web = [
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
      web = [
        "http",
        "https",
        "ephemeral"]
      app = [
        "all"]
    }
    db = {
      app = [
        "ephemeral"]
      db = [
        "all"]
    }

    management = {
      web = [
        "http",
        "https",
        "ssh",
        "rdp"]
    }
    out_internet = {
      web = [
        "ephemeral"]
      app = [
        "ephemeral"]
    }
    in_internet = {
      web = [
        "http",
        "https"]
    }

  }


  network_acl_cidr_blocks = {
    web = [
      local.tier_cidr_blocks.web]
    app = [
      local.tier_cidr_blocks.app]
    db = [
      local.tier_cidr_blocks.db]
    out_internet = local.whitelist_outgoing_http_request_cidr_blocks
    in_internet = local.whitelist_incoming_http_request_cidr_blocks
    management = local.management_network_cidr_blocks
  }


}

