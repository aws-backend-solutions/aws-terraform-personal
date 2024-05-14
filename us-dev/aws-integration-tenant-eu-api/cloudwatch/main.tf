resource "aws_cloudwatch_metric_alarm" "aws_integration_tenant_eu_lambda_cloudwatch" {
  alarm_name          = "aws-integration-tenant-eu-lambda-cloudwatch"
  alarm_description   = "Lambda Error Alarm"
  namespace           = "AWS/Lambda"
  metric_name         = "Error"
  dimensions = {
    Name  = "FunctionName"
    Value = "aws-integration-tenant-eu-function"
  }
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [ var.cloudwatch_alarm_topic_arn ]
}

resource "aws_cloudwatch_metric_alarm" "aws_integration_tenant_eu_api_gateway_cloudwatch" {
  alarm_name          = "aws-integration-tenant-eu-api-gateway-cloudwatch"
  alarm_description   = "API Gateway Error Alarm"
  namespace           = "AWS/ApiGateway"
  metric_name         = "Error"
  dimensions = {
    Name  = "ApiName"
    Value = "aws-integration-tenant-eu-api"
  }
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [ var.cloudwatch_alarm_topic_arn ]
}
