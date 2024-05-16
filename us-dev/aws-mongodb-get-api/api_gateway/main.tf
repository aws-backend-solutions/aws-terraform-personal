resource "aws_api_gateway_rest_api" "aws_mongodb_ga_api" {
  name          = "aws-mongodb-ga-api"
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

resource "aws_api_gateway_vpc_link" "aws_mongodb_ga_vpc_link" {
  name = "aws-mongodb-ga-vpc-link"
  target_arns = [var.aws_backend_vpc_endpoint_arn]
}

resource "aws_api_gateway_rest_api_policy" "api_gateway_policy" {
  rest_api_id = aws_api_gateway_rest_api.aws_mongodb_ga_api.id

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
      },
      {
        "Effect": "Deny",
        "Principal": "*",
        "Action": "execute-api:Invoke",
        "Resource": [
          "execute-api:/*"
        ],
        "Condition" : {
          "StringNotEquals": {
            "aws:SourceVpce": "${var.aws_backend_vpc_endpoint_id}"
          }
        }
      }
    ]
  }
EOF
}

resource "aws_api_gateway_deployment" "aws_mongodb_ga_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.aws_mongodb_ga_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.aws_mongodb_ga_api.body))
  }

  variables = {
    "version" = timestamp()
  }

  depends_on = [aws_api_gateway_integration.integration]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "aws_mongodb_ga_api_stage" {
  deployment_id = aws_api_gateway_deployment.aws_mongodb_ga_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.aws_mongodb_ga_api.id
  stage_name    = var.aws_environment
}

resource "aws_api_gateway_resource" "aws_mongodb_ga_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.aws_mongodb_ga_api.id
  parent_id   = aws_api_gateway_rest_api.aws_mongodb_ga_api.root_resource_id
  path_part   = var.path_part
}

resource "aws_api_gateway_method" "aws_mongodb_ga_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.aws_mongodb_ga_api.id
  resource_id   = aws_api_gateway_resource.aws_mongodb_ga_api_resource.id
  http_method   = "GET"
  authorization = "IAM"

  request_models = {
    "application/json" = "Error"
  }
}

resource "aws_api_gateway_method_settings" "method_settings" {
  rest_api_id = aws_api_gateway_rest_api.aws_mongodb_ga_api.id
  stage_name  = aws_api_gateway_stage.aws_mongodb_ga_api_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_integration" "aws_mongodb_ga_api_integration" {
  http_method             = aws_api_gateway_method.aws_mongodb_ga_api_method.http_method
  resource_id             = aws_api_gateway_resource.aws_mongodb_ga_api_resource.id
  rest_api_id             = aws_api_gateway_rest_api.aws_mongodb_ga_api.id
  type                    = "HTTP_PROXY"
  integration_http_method = "GET"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.aws_mongodb_ga_vpc_link.id
  uri                     = "http://${var.aws_backend_load_balancer_dns_name}"
}