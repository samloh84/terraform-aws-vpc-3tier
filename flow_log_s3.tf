resource "aws_flow_log" "s3" {
  traffic_type = "ALL"
  log_destination = aws_s3_bucket.flow_log.arn
  log_destination_type = "s3"
  vpc_id = aws_vpc.vpc.id
}
resource "random_string" "flow_log_s3_bucket_suffix" {

  lower = true
  number = true
  special = false
  upper = false

  length = 8
}

locals {
  flow_log_s3_bucket = "${local.vpc_name}-flow-log-${random_string.flow_log_s3_bucket_suffix.result}"
}

resource "aws_s3_bucket" "flow_log" {
  bucket = local.flow_log_s3_bucket
  acl = "private"
  force_destroy = true
  server_side_encryption_configuration {

    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
        kms_master_key_id = aws_kms_key.flow_log.arn
      }
      bucket_key_enabled = true
    }
  }


  tags = merge({
    Name = "${local.vpc_name}-flow-log"
  }, local.common_tags)
}
