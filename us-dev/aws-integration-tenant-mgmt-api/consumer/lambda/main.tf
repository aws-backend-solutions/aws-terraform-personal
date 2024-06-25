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
}

resource "aws_cloudwatch_log_group" "aws_integration_tenant_mgmt_router_function_log_group" {
  name = "/aws/lambda/${aws_lambda_function.aws_integration_tenant_mgmt_router_function.function_name}"
}