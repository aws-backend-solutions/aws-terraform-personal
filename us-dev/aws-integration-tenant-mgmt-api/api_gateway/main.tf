resource "aws_api_gateway_rest_api" "aws_integration_tenant_mgmt_api" {
  name          = "${var.prefix_name}-api"
  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = [var.aws_backend_vpc_endpoint_id]
  }

  tags = {
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
    Project     = var.project_tag
  }
}

resource "aws_api_gateway_rest_api_policy" "api_gateway_policy" {
  rest_api_id = aws_api_gateway_rest_api.aws_integration_tenant_mgmt_api.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": "execute-api:Invoke",
        "Resource": [
          "execute-api:/*"
        ]
      }
    ]
  }
EOF
}

resource "aws_api_gateway_deployment" "aws_integration_tenant_mgmt_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.aws_integration_tenant_mgmt_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.aws_integration_tenant_mgmt_api.body))
  }

  variables = {
    "version" = timestamp()
  }

  depends_on = [aws_api_gateway_integration.aws_integration_tenant_mgmt_api_integration]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "aws_integration_tenant_mgmt_api_stage" {
  deployment_id = aws_api_gateway_deployment.aws_integration_tenant_mgmt_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.aws_integration_tenant_mgmt_api.id
  stage_name    = var.stage_name
}

resource "aws_api_gateway_resource" "aws_integration_tenant_mgmt_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.aws_integration_tenant_mgmt_api.id
  parent_id   = aws_api_gateway_rest_api.aws_integration_tenant_mgmt_api.root_resource_id
  path_part   = var.path_part
}

resource "aws_api_gateway_method" "aws_integration_tenant_mgmt_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.aws_integration_tenant_mgmt_api.id
  resource_id   = aws_api_gateway_resource.aws_integration_tenant_mgmt_api_resource.id
  http_method   = "POST"
  authorization = "AWS_IAM"

  request_models = {
    "application/json" = "Error"
  }
}

resource "aws_api_gateway_method_settings" "aws_integration_tenant_mgmt_api_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.aws_integration_tenant_mgmt_api.id
  stage_name  = aws_api_gateway_stage.aws_integration_tenant_mgmt_api_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_integration" "aws_integration_tenant_mgmt_api_integration" {
  http_method             = aws_api_gateway_method.aws_integration_tenant_mgmt_api_method.http_method
  resource_id             = aws_api_gateway_resource.aws_integration_tenant_mgmt_api_resource.id
  rest_api_id             = aws_api_gateway_rest_api.aws_integration_tenant_mgmt_api.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.aws_integration_tenant_mgmt_function_invoke_arn
}