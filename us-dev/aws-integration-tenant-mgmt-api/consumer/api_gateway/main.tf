resource "aws_iam_policy" "aws_integration_tenant_mgmt_api_policy" {
  name        = "${prefix_name}-api-policy"
  description = "Policy to allow invoking the API Gateway and VPC read-only access"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "AllowInvokeAPI",
        Effect   = "Allow",
        Action   = "execute-api:Invoke",
        Resource = "arn:aws:execute-api:us-west-2:${var.aws_account_id}:${var.primary_aws_integration_tenant_mgmt_api_id}/*"
      },
      {
        Sid    = "AllowVPCReadOnlyAccess",
        Effect = "Allow",
        Action = [
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "aws_integration_tenant_mgmt_api_role" {
  name = "${prefix_name}-api-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_integration_tenant_mgmt_api_attachment" {
  role       = aws_iam_role.aws_integration_tenant_mgmt_api_role.name
  policy_arn = aws_iam_policy.aws_integration_tenant_mgmt_api_policy.arn
}


##### /health

resource "aws_api_gateway_resource" "aws_integration_tenant_mgmt_api_health_resource" {
  rest_api_id = var.primary_aws_integration_tenant_mgmt_api_id
  parent_id   = var.primary_aws_integration_tenant_mgmt_api_root_resource_id
  path_part   = "health"
}

resource "aws_api_gateway_method" "aws_integration_tenant_mgmt_api_health_method" {
  rest_api_id   = var.primary_aws_integration_tenant_mgmt_api_id
  resource_id   = aws_api_gateway_resource.aws_integration_tenant_mgmt_api_health_resource.id
  http_method   = "GET"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "aws_integration_tenant_mgmt_api_health_integration" {
  rest_api_id             = var.primary_aws_integration_tenant_mgmt_api_id
  resource_id             = aws_api_gateway_resource.aws_integration_tenant_mgmt_api_health_resource.id
  http_method             = aws_api_gateway_method.aws_integration_tenant_mgmt_api_health_method.http_method
  type                    = "MOCK"
  request_templates       = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "aws_integration_tenant_mgmt_api_health_method_response" {
  rest_api_id = var.primary_aws_integration_tenant_mgmt_api_id
  resource_id = aws_api_gateway_resource.aws_integration_tenant_mgmt_api_health_resource.id
  http_method = aws_api_gateway_method.aws_integration_tenant_mgmt_api_health_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "aws_integration_tenant_mgmt_api_health_integration_response" {
  rest_api_id = var.primary_aws_integration_tenant_mgmt_api_id
  resource_id = aws_api_gateway_resource.aws_integration_tenant_mgmt_api_health_resource.id
  http_method = aws_api_gateway_method.aws_integration_tenant_mgmt_api_health_method.http_method
  status_code = aws_api_gateway_method_response.aws_integration_tenant_mgmt_api_health_method_response.status_code
  response_templates = {
    "application/json" = jsonencode({
      message = "OK"
    })
  }
}

##### /us-staging

resource "aws_api_gateway_resource" "aws_integration_tenant_mgmt_api_us_staging_resource" {
  rest_api_id = var.primary_aws_integration_tenant_mgmt_api_id
  parent_id   = var.primary_aws_integration_tenant_mgmt_api_root_resource_id
  path_part   = var.path_part
}

resource "aws_api_gateway_method" "aws_integration_tenant_mgmt_api_us_staging_method" {
  rest_api_id   = var.primary_aws_integration_tenant_mgmt_api_id
  resource_id   = aws_api_gateway_resource.aws_integration_tenant_mgmt_api_us_staging_resource.id
  http_method   = "POST"
  authorization = "AWS_IAM"

  request_models = {
    "application/json" = "Error"
  }
}

resource "aws_api_gateway_method_settings" "aws_integration_tenant_mgmt_api_us_staging_method_settings" {
  rest_api_id = var.primary_aws_integration_tenant_mgmt_api_id
  stage_name  = aws_api_gateway_stage.primary_aws_integration_tenant_mgmt_api_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_integration" "aws_integration_tenant_mgmt_api_us_staging_integration" {
  http_method             = aws_api_gateway_method.aws_integration_tenant_mgmt_api_us_staging_method.http_method
  resource_id             = aws_api_gateway_resource.aws_integration_tenant_mgmt_api_us_staging_resource.id
  rest_api_id             = var.primary_aws_integration_tenant_mgmt_api_id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.aws_integration_tenant_mgmt_function_us_staging_invoke_arn
}

resource "aws_api_gateway_stage" "primary_aws_integration_tenant_mgmt_api_stage" {
  deployment_id = aws_api_gateway_deployment.primary_aws_integration_tenant_mgmt_api_deployment.id
  rest_api_id   = var.primary_aws_integration_tenant_mgmt_api_id
  stage_name    = var.stage_name
}

resource "aws_api_gateway_deployment" "primary_aws_integration_tenant_mgmt_api_deployment" {
  rest_api_id = var.primary_aws_integration_tenant_mgmt_api_id

  depends_on = [
    aws_api_gateway_integration.aws_integration_tenant_mgmt_api_us_staging_integration,
    aws_api_gateway_integration.aws_integration_tenant_mgmt_api_health_integration
  ]
  
  lifecycle {
    create_before_destroy = true
  }
}