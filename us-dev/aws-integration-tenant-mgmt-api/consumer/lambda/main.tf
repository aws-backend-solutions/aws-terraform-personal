resource "aws_iam_role" "aws_integration_tenant_mgmt_router_function_role" {
  name = "${var.prefix_name}-router-function-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  ]
}

##### /router lambda

resource "aws_lambda_function" "aws_integration_tenant_mgmt_router_function" {
  function_name = "${var.prefix_name}-router-function"
  description   = "Lambda function that routes requests to appropriate VPC endpoints for ${var.prefix_name}."
  handler       = "app.lambda_handler"
  runtime       = "python3.9"
  timeout       = 60
  role          = aws_iam_role.aws_integration_tenant_mgmt_router_function_role.arn
  filename      = "${path.module}/code/${var.prefix_name}-router-function.zip"

  environment {
    variables = {
      stage_name = var.stage_name
    }
  }

  tags = {
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
    Project     = var.project_tag
  }

  vpc_config {
    security_group_ids = [
      var.primary_aws_backend_security_group2_id
    ]
    subnet_ids = [
      var.primary_aws_backend_private_subnet1_id,
      var.primary_aws_backend_private_subnet2_id
    ]
  }
}

resource "aws_cloudwatch_log_group" "aws_integration_tenant_mgmt_router_function_log_group" {
  name = "/aws/lambda/${aws_lambda_function.aws_integration_tenant_mgmt_router_function.function_name}"
}

resource "aws_lambda_permission" "aws_integration_tenant_mgmt_router_function_invoke_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws_integration_tenant_mgmt_router_function.arn
  principal     = "apigateway.amazonaws.com"
}