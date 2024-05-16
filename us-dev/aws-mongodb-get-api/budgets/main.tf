resource "aws_budgets_budget" "aws_mongodb_ga_lambda_budget" {
  name         = "${var.prefix_name}-lambda-budget"
  budget_type  = "COST"
  limit_amount = var.lambda_budget_limit_amount
  limit_unit   = "USD"
  time_unit    = var.lambda_budget_time_unit

  cost_filter {
    name = "TagKeyValue"
    values = [
      "Project${"$"}${var.project_tag}",
    ]
  }

  notification {
    notification_type         = "ACTUAL"
    comparison_operator       = "GREATER_THAN"
    threshold                 = 0.1
    threshold_type            = "ABSOLUTE_VALUE"
    subscriber_sns_topic_arns = [var.budget_alert_topic_arn]
  }
}

resource "aws_budgets_budget" "aws_mongodb_ga_api_gateway_budget" {
  name         = "${var.prefix_name}-api-gateway-budget"
  budget_type  = "COST"
  limit_amount = var.api_gateway_budget_limit_amount
  limit_unit   = "USD"
  time_unit    = var.api_gateway_budget_time_unit

  cost_filter {
    name = "TagKeyValue"
    values = [
      "Project${"$"}${var.project_tag}",
    ]
  }

  notification {
    notification_type         = "ACTUAL"
    comparison_operator       = "GREATER_THAN"
    threshold                 = 0.1
    threshold_type            = "ABSOLUTE_VALUE"
    subscriber_sns_topic_arns = [var.budget_alert_topic_arn]
  }
}