resource "aws_api_gateway_rest_api" "aws_customer_data_upload_api" {
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
  rest_api_id = aws_api_gateway_rest_api.aws_customer_data_upload_api.id

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

resource "aws_api_gateway_deployment" "aws_customer_data_upload_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.aws_customer_data_upload_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.aws_customer_data_upload_api.body))
  }

  variables = {
    "version" = timestamp()
  }

  depends_on = [
    aws_api_gateway_integration.aws_customer_data_upload_api_integration1,
    aws_api_gateway_integration.aws_customer_data_upload_api_integration2,
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "aws_customer_data_upload_api_stage" {
  deployment_id = aws_api_gateway_deployment.aws_customer_data_upload_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.aws_customer_data_upload_api.id
  stage_name    = var.stage_name
}

resource "aws_api_gateway_resource" "aws_customer_data_upload_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.aws_customer_data_upload_api.id
  parent_id   = aws_api_gateway_rest_api.aws_customer_data_upload_api.root_resource_id
  path_part   = var.path_part
}

##### method for the upload and generate lambda #####

resource "aws_api_gateway_method" "aws_customer_data_upload_api_method1" {
  rest_api_id   = aws_api_gateway_rest_api.aws_customer_data_upload_api.id
  resource_id   = aws_api_gateway_resource.aws_customer_data_upload_api_resource.id
  http_method   = "PUT"
  authorization = "AWS_IAM"

  request_models = {
    "application/json" = "Error"
  }
}

resource "aws_api_gateway_method_settings" "aws_customer_data_upload_api_method_settings1" {
  rest_api_id = aws_api_gateway_rest_api.aws_customer_data_upload_api.id
  stage_name  = aws_api_gateway_stage.aws_customer_data_upload_api_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_integration" "aws_customer_data_upload_api_integration1" {
  http_method             = aws_api_gateway_method.aws_customer_data_upload_api_method1.http_method
  resource_id             = aws_api_gateway_resource.aws_customer_data_upload_api_resource.id
  rest_api_id             = aws_api_gateway_rest_api.aws_customer_data_upload_api.id
  type                    = "AWS"
  integration_http_method = "PUT"
  credentials             = "${var.aws_backend_api_gateway_role_name}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:s3:path/{bucket}/{folder}"

  request_parameters = {
    "integration.request.header.x-amz-meta-fileinfo" = "method.request.header.x-amz-meta-fileinfo"
    "integration.request.header.Accept"              = "method.request.header.Accept"
    "integration.request.header.Content-Type"        = "method.request.header.Content-Type"

    "integration.request.path.bucket" = "method.request.path.bucket"
    "integration.request.path.folder" = "method.request.path.folder"
  }
}

# resource "aws_api_gateway_method" "aws_customer_data_upload_api_method1" {
#   rest_api_id   = aws_api_gateway_rest_api.aws_customer_data_upload_api.id
#   resource_id   = aws_api_gateway_resource.aws_customer_data_upload_api_resource.id
#   http_method   = "POST"
#   authorization = "AWS_IAM"

#   request_models = {
#     "application/json" = "Error"
#   }
# }

# resource "aws_api_gateway_method_settings" "aws_customer_data_upload_api_method_settings1" {
#   rest_api_id = aws_api_gateway_rest_api.aws_customer_data_upload_api.id
#   stage_name  = aws_api_gateway_stage.aws_customer_data_upload_api_stage.stage_name
#   method_path = "*/*"

#   settings {
#     metrics_enabled = true
#     logging_level   = "INFO"
#   }
# }

# resource "aws_api_gateway_integration" "aws_customer_data_upload_api_integration1" {
#   http_method             = aws_api_gateway_method.aws_customer_data_upload_api_method1.http_method
#   resource_id             = aws_api_gateway_resource.aws_customer_data_upload_api_resource.id
#   rest_api_id             = aws_api_gateway_rest_api.aws_customer_data_upload_api.id
#   type                    = "AWS_PROXY"
#   integration_http_method = "POST"
#   uri                     = var.aws_customer_data_upload_function_invoke_arn1
# }

##### method for the regenerate lambda #####

resource "aws_api_gateway_method" "aws_customer_data_upload_api_method2" {
  rest_api_id   = aws_api_gateway_rest_api.aws_customer_data_upload_api.id
  resource_id   = aws_api_gateway_resource.aws_customer_data_upload_api_resource.id
  http_method   = "GET"
  authorization = "AWS_IAM"

  request_models = {
    "application/json" = "Error"
  }
}

resource "aws_api_gateway_method_settings" "aws_customer_data_upload_api_method_settings2" {
  rest_api_id = aws_api_gateway_rest_api.aws_customer_data_upload_api.id
  stage_name  = aws_api_gateway_stage.aws_customer_data_upload_api_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_integration" "aws_customer_data_upload_api_integration2" {
  http_method             = aws_api_gateway_method.aws_customer_data_upload_api_method2.http_method
  resource_id             = aws_api_gateway_resource.aws_customer_data_upload_api_resource.id
  rest_api_id             = aws_api_gateway_rest_api.aws_customer_data_upload_api.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.aws_customer_data_upload_function_invoke_arn2
}