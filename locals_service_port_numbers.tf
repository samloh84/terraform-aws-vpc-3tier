locals {
  service_port_numbers = {
    rdp = {
      protocol = "tcp"
      from_port = 3389
      to_port = 3389
      service_name = "RDP"
    }
    ssh = {
      protocol = "tcp"
      from_port = 22
      to_port = 22
      service_name = "SSH"
    }
    http = {
      protocol = "tcp"
      from_port = 80
      to_port = 80
      service_name = "HTTP"
    }
    https = {
      protocol = "tcp"
      from_port = 443
      to_port = 443
      service_name = "HTTPS"
    }

    mysql = {
      protocol = "tcp"
      from_port = 3306
      to_port = 3306
      service_name = "MySQL"
    }
    mssql = {
      protocol = "tcp"
      from_port = 1433
      to_port = 1433
      service_name = "Microsoft SQL"
    }
    oracledb = {
      protocol = "tcp"
      from_port = 1521
      to_port = 1521
      service_name = "Oracle Database"
    }
    postgresql = {
      protocol = "tcp"
      from_port = 5432
      to_port = 5432
      service_name = "PostgreSQL"
    }
    mongodb = {
      protocol = "tcp"
      from_port = 27017
      to_port = 27017
      service_name = "MongoDB"
    }
    memcached = {
      protocol = "tcp"
      from_port = 11211
      to_port = 11211
      service_name = "Memcached"
    }
    redis = {
      protocol = "tcp"
      from_port = 6379
      to_port = 6379
      service_name = "Redis"
    }
    all = {
      protocol = "-1"
      from_port = 0
      to_port = 65535
      service_name = "all"
    }
    ephemeral = {
      protocol = "-1"
      from_port = 1024
      to_port = 65535
      service_name = "ephemeral"
    }

  }
}