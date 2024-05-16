resource "aws_iam_role" "aws_mongodb_ga_function_role" {
  name = "MongoDbRoaFunctionRole"
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
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
  ]
}

resource "aws_lambda_function" "aws_mongodb_ga_function" {
  function_name    = var.lambda_function_name
  description      = "Lambda function that retrieves specific document(s)."
  handler          = "app.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60
  role             = aws_iam_role.aws_mongodb_ga_function_role.arn
  filename         = "${path.module}/code/${var.lambda_function_name}.zip"

  environment {
    variables = {
      MONGODB_URI   = var.mongodb_url
      DATABASE_NAME = var.mongodb_name
    }
  }

  tags = {
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
    Project     = var.project_tag
  }

  vpc_config {
    security_group_ids = [
      var.aws_backend_security_group2_id
    ]
    subnet_ids = [
      var.aws_backend_private_subnet1_id,
      var.aws_backend_private_subnet2_id
    ]
  }
}

resource "aws_cloudwatch_log_group" "aws_mongodb_ga_function_log_group" {
  name = "/aws/lambda/${aws_lambda_function.aws_mongodb_ga_function.function_name}"
}

resource "aws_lambda_permission" "aws_mongodb_ga_function_invoke_permission" {
  statement_id  = "AllowExecutionFromELB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws_mongodb_ga_function.arn
  principal     = "elasticloadbalancing.amazonaws.com"
}