# policy for invoking the API endpoint

resource "aws_iam_policy" "aws_integration_tenant_mgmt_api_policy" {
  name        = "${var.prefix_name}-api-policy"
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

# policy for invoking sqs

resource "aws_iam_role" "aws_integration_tenant_mgmt_api_sqs_role" {
  name = "${var.prefix_name}-api-sqs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "apigateway.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "aws_integration_tenant_mgmt_api_sqs_policy" {
  name        = "${var.prefix_name}-api-sqs-policy"
  description = "Policy to allow API Gateway to send messages to SQS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "sqs:SendMessage",
      Resource = "${var.aws_integration_tenant_mgmt_sqs_queue_arn}"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "aws_integration_tenant_mgmt_api_sqs_policy_attachment" {
  role       = aws_iam_role.aws_integration_tenant_mgmt_api_sqs_role.name
  policy_arn = aws_iam_policy.aws_integration_tenant_mgmt_api_sqs_policy.arn
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

##### /tenants

resource "aws_api_gateway_resource" "aws_integration_tenant_mgmt_api_tenants_resource" {
  rest_api_id = var.primary_aws_integration_tenant_mgmt_api_id
  parent_id   = var.primary_aws_integration_tenant_mgmt_api_root_resource_id
  path_part   = "tenants"
}

resource "aws_api_gateway_method" "aws_integration_tenant_mgmt_api_tenants_method" {
  rest_api_id   = var.primary_aws_integration_tenant_mgmt_api_id
  resource_id   = aws_api_gateway_resource.aws_integration_tenant_mgmt_api_tenants_resource.id
  http_method   = "POST"
  authorization = "AWS_IAM"

  request_models = {
    "application/json" = "Error"
  }
}

resource "aws_api_gateway_method_settings" "aws_integration_tenant_mgmt_api_tenants_method_settings" {
  rest_api_id = var.primary_aws_integration_tenant_mgmt_api_id
  stage_name  = aws_api_gateway_stage.primary_aws_integration_tenant_mgmt_api_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_integration" "aws_integration_tenant_mgmt_api_tenants_integration" {
  http_method             = aws_api_gateway_method.aws_integration_tenant_mgmt_api_tenants_method.http_method
  resource_id             = aws_api_gateway_resource.aws_integration_tenant_mgmt_api_tenants_resource.id
  rest_api_id             = var.primary_aws_integration_tenant_mgmt_api_id
  type                    = "AWS"
  integration_http_method = "POST"
  credentials             = aws_iam_role.aws_integration_tenant_mgmt_api_sqs_role.arn
  uri                     = "arn:aws:apigateway:${var.aws_region}:sqs:path/${var.aws_account_id}/${var.aws_integration_tenant_mgmt_sqs_queue_name}"

  request_templates = {
    "application/json" = jsonencode({
      "Action": "SendMessage",
      "MessageBody": "$input.json('$')"
    })
  }
}

# deployment - only needs to be created once

resource "aws_api_gateway_stage" "primary_aws_integration_tenant_mgmt_api_stage" {
  deployment_id = aws_api_gateway_deployment.primary_aws_integration_tenant_mgmt_api_deployment.id
  rest_api_id   = var.primary_aws_integration_tenant_mgmt_api_id
  stage_name    = var.stage_name
}

resource "aws_api_gateway_deployment" "primary_aws_integration_tenant_mgmt_api_deployment" {
  rest_api_id = var.primary_aws_integration_tenant_mgmt_api_id

  depends_on = [
    aws_api_gateway_integration.aws_integration_tenant_mgmt_api_health_integration,
    aws_api_gateway_integration.aws_integration_tenant_mgmt_api_tenants_integration
  ]
  
  lifecycle {
    create_before_destroy = true
  }
}