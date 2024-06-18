resource "aws_cloudwatch_metric_alarm" "aws_integration_tenant_mgmt_lambda_cloudwatch" {
  alarm_name          = "${var.prefix_name}-lambda-cloudwatch"
  alarm_description   = "Lambda Error Alarm"
  namespace           = "AWS/Lambda"
  metric_name         = "Error"
  dimensions = {
    Name  = "FunctionName"
    Value = "${var.prefix_name}-function"
  }
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [ var.cloudwatch_alarm_topic_arn ]
}

resource "aws_cloudwatch_metric_alarm" "aws_integration_tenant_mgmt_api_gateway_cloudwatch" {
  alarm_name          = "${var.prefix_name}-api-gateway-cloudwatch"
  alarm_description   = "API Gateway Error Alarm"
  namespace           = "AWS/ApiGateway"
  metric_name         = "Error"
  dimensions = {
    Name  = "ApiName"
    Value = "${var.prefix_name}-api"
  }
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [ var.cloudwatch_alarm_topic_arn ]
}
