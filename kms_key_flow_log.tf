resource "aws_kms_key" "flow_log" {

  description = "CMK for encryption of flow logs of VPC ${local.vpc_name}"
  key_usage = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  policy = data.aws_iam_policy_document.flow_log_kms_key_policy.json
  enable_key_rotation = true

  tags = merge({
    Name = "${local.vpc_name}-flow-log"
  }, local.common_tags)
}

resource "aws_kms_alias" "flow_log" {
  target_key_id = aws_kms_key.flow_log.id
  name = "alias/${local.vpc_name}-flow-log-${random_string.flow_log_kms_key_suffix.result}"
}


resource "random_string" "flow_log_kms_key_suffix" {

  lower = true
  number = true
  special = false
  upper = false


  length = 8
}


data "aws_iam_policy_document" "flow_log_kms_key_policy" {
  statement {

    effect = "Allow"
    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.caller_identity.account_id}:root"]
      type = "AWS"
    }
    actions = [
      "kms:*"]
    resources = [
      "*"]
  }
  statement {

    effect = "Allow"
    principals {
      identifiers = [
        "logs.ap-southeast-1.amazonaws.com"]
      type = "Service"
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"]
    resources = [
      "*"]
    condition {
      test = "ArnEquals"
      values = [
        "arn:aws:logs:${data.aws_region.region.name}:${data.aws_caller_identity.caller_identity.account_id}:log-group:${local.flow_log_cloudwatch_log_group_name}"]
      variable = "kms:EncryptionContext:aws:logs:arn"
    }
  }

  statement {

    effect = "Allow"
    principals {
      identifiers = [
        "delivery.logs.amazonaws.com"]
      type = "Service"
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"]
    resources = [
      "*"]
    condition {
      test = "ArnLike"
      values = [
        "arn:aws:logs:::${local.flow_log_s3_bucket}/*"]
      variable = "kms:EncryptionContext:aws:s3:arn"
    }
  }


}