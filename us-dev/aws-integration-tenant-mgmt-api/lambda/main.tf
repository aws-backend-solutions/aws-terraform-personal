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
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
  ]
}

resource "aws_lambda_function" "aws_integration_tenant_mgmt_function" {
  function_name    = var.lambda_function_name
  description      = "Lambda function that creates tenant from oregon to frankfurt and vice versa."
  handler          = "app.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60
  role             = aws_iam_role.aws_integration_tenant_mgmt_function_role.arn
  filename         = "${path.module}/code/${var.lambda_function_name}.zip"

  environment {
    variables = {
      OREGON_DEV: var.us_dev_domain
      OREGON_STAGING: var.us_stage_domain
      OREGON_PROD: var.us_prod_domain
      OREGON_DEV_URI = var.us_dev_url
      OREGON_STAGE_URI = var.us_stage_url
      OREGON_PROD_URI = var.us_prod_url
      OREGON_DEV_DB = var.us_dev_db
      OREGON_STAGE_DB = var.us_stage_db
      OREGON_PROD_DB = var.us_prod_db
      OREGON_DEV_USR: var.us_dev_usr
      OREGON_STAGING_USR: var.us_stage_usr
      OREGON_PROD_USR: var.us_prod_usr
      OREGON_DEV_PWD: var.us_dev_pwd
      OREGON_STAGING_PWD: var.us_stage_pwd
      OREGON_PROD_PWD: var.us_prod_pwd

      FRANKFURT_STAGING: var.eu_stage_domain
      FRANKFURT_PROD: var.eu_prod_domain
      FRANKFURT_STAGE_URI = var.eu_stage_url
      FRANKFURT_PROD_URI = var.eu_prod_url
      FRANKFURT_STAGE_DB = var.eu_stage_db
      FRANKFURT_PROD_DB = var.eu_prod_db
      FRANKFURT_STAGING_USR: var.eu_stage_usr
      FRANKFURT_STAGING_PWD: var.eu_stage_pwd
      FRANKFURT_PROD_USR: var.eu_prod_usr
      FRANKFURT_PROD_PWD: var.eu_prod_pwd

      COLLECTION_NAME: var.collection_name
      API_ENDPOINT: var.api_endpoint
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

resource "aws_cloudwatch_log_group" "aws_integration_tenant_mgmt_function_log_group" {
  name = "/aws/lambda/${aws_lambda_function.aws_integration_tenant_mgmt_function.function_name}"
}

resource "aws_lambda_permission" "aws_integration_tenant_mgmt_function_invoke_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws_integration_tenant_mgmt_function.arn
  principal     = "apigateway.amazonaws.com"
}