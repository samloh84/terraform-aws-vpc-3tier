resource "aws_flow_log" "cloudwatch_log_group" {
  traffic_type = "ALL"
  log_destination = aws_cloudwatch_log_group.flow_log.arn
  log_destination_type = "cloud-watch-logs"
  iam_role_arn = aws_iam_role.flow_log_cloudwatch_log_group_iam_role.arn
  vpc_id = aws_vpc.vpc.id
}

resource "random_string" "flow_log_cloudwatch_log_group_suffix" {

  lower = true
  number = true
  special = false
  upper = false


  length = 8
}

locals {
  flow_log_cloudwatch_log_group_name = "${local.vpc_name}-flow-log-${random_string.flow_log_cloudwatch_log_group_suffix.result}"
}

resource "aws_cloudwatch_log_group" "flow_log" {
  name = local.flow_log_cloudwatch_log_group_name
  retention_in_days = 0
  kms_key_id = aws_kms_key.flow_log.arn

  tags = merge({
    Name = "${local.vpc_name}-flow-log"
  }, local.common_tags)
}

resource "aws_iam_role" "flow_log_cloudwatch_log_group_iam_role" {
  name = "${local.flow_log_cloudwatch_log_group_name}-iam-role"
  assume_role_policy = data.aws_iam_policy_document.flow_log_cloudwatch_log_group_iam_role_assume_role_policy.json
}


resource "aws_iam_role_policy" "flow_log_cloudwatch_log_group_iam_role_assume_role_policy" {
  name = "${local.flow_log_cloudwatch_log_group_name}-iam-role-iam-policy"
  role = aws_iam_role.flow_log_cloudwatch_log_group_iam_role.id
  policy = data.aws_iam_policy_document.flow_log_cloudwatch_log_group_iam_role_iam_policy.json

}


data "aws_iam_policy_document" "flow_log_cloudwatch_log_group_iam_role_iam_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = [
      "arn:aws:logs:ap-southeast-1:${data.aws_caller_identity.caller_identity.account_id}:log-group:${local.flow_log_cloudwatch_log_group_name}:*"
    ]
  }


}

data "aws_iam_policy_document" "flow_log_cloudwatch_log_group_iam_role_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = [
        "vpc-flow-logs.amazonaws.com"]
      type = "Service"
    }
    actions = [
      "sts:AssumeRole"
    ]

  }


}