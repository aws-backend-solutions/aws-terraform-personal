# resource "aws_apigatewayv2_vpc_link" "aws_mongodb_ga_vpc_link" {
#   name = "aws-mongodb-ga-vpc-link"
#   security_group_ids = [
#     var.aws_backend_security_group2_id
#   ]
#   subnet_ids = [
#     var.aws_backend_private_subnet1_id,
#     var.aws_backend_private_subnet2_id
#   ]
# }

resource "aws_apigatewayv2_api" "aws_mongodb_ga_api" {
  name          = "aws-mongodb-ga-api"
  protocol_type = "HTTP"

  tags = {
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
    Project     = var.project_tag
  }
}

resource "aws_cloudwatch_log_group" "aws_mongodb_ga_api_log_group" {
  name = "/aws/api-gateway/${aws_apigatewayv2_api.aws_mongodb_ga_api.name}"
}

resource "aws_apigatewayv2_stage" "aws_mongodb_ga_api_stage" {
  api_id      = aws_apigatewayv2_api.aws_mongodb_ga_api.id
  auto_deploy = true
  name        = var.aws_environment

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.aws_mongodb_ga_api_log_group.arn
    format          = "{ \"requestId\": \"$context.requestId\", \"ip\": \"$context.identity.sourceIp\", \"requestTime\": \"$context.requestTime\", \"httpMethod\": \"$context.httpMethod\", \"routeKey\": \"$context.routeKey\", \"status\": \"$context.status\", \"protocol\": \"$context.protocol\", \"responseLength\": \"$context.responseLength\" }"
  }
}

resource "aws_apigatewayv2_integration" "aws_mongodb_ga_api_integration" {
  api_id                 = aws_apigatewayv2_api.aws_mongodb_ga_api.id
  # connection_type        = "VPC_LINK"
  # connection_id          = aws_apigatewayv2_vpc_link.aws_mongodb_ga_vpc_link.id
  integration_method     = "GET"
  integration_type       = "HTTP_PROXY"
  integration_uri        = var.aws_backend_load_balancer_listener_id
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "aws_mongodb_ga_api_route" {
  api_id             = aws_apigatewayv2_api.aws_mongodb_ga_api.id
  route_key          = "GET /${var.path_part}"
  target             = "integrations/${aws_apigatewayv2_integration.aws_mongodb_ga_api_integration.id}"
  authorization_type = "AWS_IAM"
}

resource "aws_apigatewayv2_deployment" "aws_mongodb_ga_api_deployment" {
  api_id = aws_apigatewayv2_api.aws_mongodb_ga_api.id

  depends_on = [
    aws_apigatewayv2_route.aws_mongodb_ga_api_route
  ]
}