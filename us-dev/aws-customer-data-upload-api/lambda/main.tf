resource "aws_iam_policy" "aws_customer_data_upload_function_s3_policy" {
  name = "${var.prefix_name}-function-s3-policy"
  description = "IAM policy for Lambda to access S3 bucket"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${var.aws_customer_data_upload_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "aws_customer_data_upload_function_role" {
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
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
    aws_iam_policy.aws_customer_data_upload_function_s3_policy.arn,
  ]
}

##### lambda for the new upload and generate #####

resource "aws_lambda_function" "aws_customer_data_upload_function1" {
  function_name    = var.new_function_name
  description      = "Lambda function that saves the payload into an s3 object and generates new pre-signed url to access it."
  handler          = "app.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60
  role             = aws_iam_role.aws_customer_data_upload_function_role.arn
  filename         = "${path.module}/${var.new_function_name}/${var.new_function_name}.zip"

  environment {
    variables = {
      # "BUCKET_NAME": var.bucket_name
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

resource "aws_cloudwatch_log_group" "aws_customer_data_upload_function_log_group1" {
  name = "/aws/lambda/${aws_lambda_function.aws_customer_data_upload_function1.function_name}"
}

resource "aws_lambda_permission" "aws_customer_data_upload_function_invoke_permission1" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws_customer_data_upload_function1.arn
  principal     = "apigateway.amazonaws.com"
}

##### lambda for the renew generate #####

resource "aws_lambda_function" "aws_customer_data_upload_function2" {
  function_name    = var.renew_function_name
  description      = "Lambda function that regenerates new pre-signed url for the s3 object."
  handler          = "app.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60
  role             = aws_iam_role.aws_customer_data_upload_function_role.arn
  filename         = "${path.module}/${var.renew_function_name}/${var.renew_function_name}.zip"

  environment {
    variables = {

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

resource "aws_cloudwatch_log_group" "aws_customer_data_upload_function_log_group2" {
  name = "/aws/lambda/${aws_lambda_function.aws_customer_data_upload_function2.function_name}"
}

resource "aws_lambda_permission" "aws_customer_data_upload_function_invoke_permission2" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws_customer_data_upload_function2.arn
  principal     = "apigateway.amazonaws.com"
}