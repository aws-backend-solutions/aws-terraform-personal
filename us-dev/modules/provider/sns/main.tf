resource "aws_sns_topic" "budget_alert_topic" {
  name = "${var.prefix_name}-topic-budget-threshold"

  tags = {
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_sns_topic_subscription" "budget_alert_topic_subscription" {
  topic_arn = aws_sns_topic.budget_alert_topic.arn
  protocol  = "email"
  endpoint  = var.recipient_for_budgets
}

resource "aws_sns_topic_policy" "budget_alert_topic_policy" {
  arn = aws_sns_topic.budget_alert_topic.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "budgets.amazonaws.com"
      }
      Action   = "sns:Publish"
      Resource = "${aws_sns_topic.budget_alert_topic.arn}"
    }]
  })
}

resource "aws_sns_topic" "cloudwatch_alarm_topic" {
  name = "${var.prefix_name}-topic-cloudwatch-errors"

  tags = {
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_sns_topic_subscription" "cloudwatch_alarm_topic_subscription" {
  topic_arn = aws_sns_topic.cloudwatch_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.recipient_for_cloudwatch
}

resource "aws_sns_topic_policy" "cloudwatch_alarm_topic_policy" {
  arn = aws_sns_topic.cloudwatch_alarm_topic.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "budgets.amazonaws.com"
      }
      Action   = "sns:Publish"
      Resource = "${aws_sns_topic.cloudwatch_alarm_topic.arn}"
    }]
  })
}