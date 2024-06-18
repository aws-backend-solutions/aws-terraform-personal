resource "aws_api_gateway_rest_api" "primary_aws_integration_tenant_mgmt_api" {
  name          = "primary-${var.prefix_name}-api"
  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = [var.primary_aws_backend_vpc_endpoint_id]
  }

  tags = {
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
    Project     = var.project_tag
  }
}

resource "aws_api_gateway_rest_api_policy" "primary_api_gateway_policy" {
  rest_api_id = aws_api_gateway_rest_api.primary_aws_integration_tenant_mgmt_api.id

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

resource "aws_api_gateway_deployment" "primary_aws_integration_tenant_mgmt_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.primary_aws_integration_tenant_mgmt_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.primary_aws_integration_tenant_mgmt_api.body))
  }

  variables = {
    "version" = timestamp()
  }

  depends_on = [aws_api_gateway_integration.primary_aws_integration_tenant_mgmt_api_integration]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "primary_aws_integration_tenant_mgmt_api_stage" {
  deployment_id = aws_api_gateway_deployment.primary_aws_integration_tenant_mgmt_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.primary_aws_integration_tenant_mgmt_api.id
  stage_name    = var.stage_name
}

resource "aws_api_gateway_resource" "primary_aws_integration_tenant_mgmt_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.primary_aws_integration_tenant_mgmt_api.id
  parent_id   = aws_api_gateway_rest_api.primary_aws_integration_tenant_mgmt_api.root_resource_id
  path_part   = var.path_part
}

resource "aws_api_gateway_method" "primary_aws_integration_tenant_mgmt_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.primary_aws_integration_tenant_mgmt_api.id
  resource_id   = aws_api_gateway_resource.primary_aws_integration_tenant_mgmt_api_resource.id
  http_method   = "POST"
  authorization = "AWS_IAM"

  request_models = {
    "application/json" = "Error"
  }
}

resource "aws_api_gateway_method_settings" "primary_aws_integration_tenant_mgmt_api_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.primary_aws_integration_tenant_mgmt_api.id
  stage_name  = aws_api_gateway_stage.primary_aws_integration_tenant_mgmt_api_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_integration" "primary_aws_integration_tenant_mgmt_api_integration" {
  http_method             = aws_api_gateway_method.primary_aws_integration_tenant_mgmt_api_method.http_method
  resource_id             = aws_api_gateway_resource.primary_aws_integration_tenant_mgmt_api_resource.id
  rest_api_id             = aws_api_gateway_rest_api.primary_aws_integration_tenant_mgmt_api.id
  type                    = "HTTP_PROXY"
  integration_http_method = "POST"
  uri                     = var.primary_aws_backend_nlb_dns
  connection_type         = "VPC_LINK"
  connection_id           = "ej140y"
}