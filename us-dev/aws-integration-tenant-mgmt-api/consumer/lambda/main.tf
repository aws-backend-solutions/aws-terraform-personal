resource "aws_iam_role" "aws_integration_tenant_mgmt_function_role" {
  name = "${var.prefix_name}-function-role"
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

data "aws_iam_policy_document" "aws_integration_tenant_mgmt_function_sqs_document" {
  statement {
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [
      var.aws_integration_tenant_mgmt_sqs_queue_arn
    ]
  }
}

resource "aws_iam_policy" "aws_integration_tenant_mgmt_function_sqs_policy" {
  name        = "${var.prefix_name}-sqs-policy"
  description = "Allow Lambda to interact with SQS"
  policy      = data.aws_iam_policy_document.aws_integration_tenant_mgmt_function_sqs_document.json
}

resource "aws_iam_role_policy_attachment" "aws_integration_tenant_mgmt_function_sqs_policy_attachment" {
  policy_arn = aws_iam_policy.aws_integration_tenant_mgmt_function_sqs_policy.arn
  role       = aws_iam_role.aws_integration_tenant_mgmt_function_role.name
}

##### /router lambda

resource "aws_lambda_function" "aws_integration_tenant_mgmt_function_router" {
  function_name = "${var.prefix_name}-router-function"
  description   = "Lambda function that routes requests to appropriate VPC endpoints for ${var.prefix_name}."
  handler       = "app.lambda_handler"
  runtime       = "python3.9"
  timeout       = 60
  role          = aws_iam_role.aws_integration_tenant_mgmt_function_role.arn
  filename      = "${path.module}/code/${var.prefix_name}-router-function.zip"
}

resource "aws_lambda_event_source_mapping" "aws_integration_tenant_mgmt_function_mapping" {
  event_source_arn = var.aws_integration_tenant_mgmt_sqs_queue_arn
  function_name    = aws_lambda_function.aws_integration_tenant_mgmt_function_router.arn
  batch_size       = 10
}
