resource "aws_iam_role" "aws_backend_api_gateway_role" {
  name               = "${var.prefix_name}-api-gateway-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "aws_backend_api_gateway_cloudwatch_logs_policy" {
  name        = "${var.prefix_name}-api-gateway-cloudwatch-logs-policy"
  description = "Allows API Gateway to push logs to CloudWatch Logs"
  
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_attachment" {
  role       = aws_iam_role.aws_backend_api_gateway_role.name
  policy_arn = aws_iam_policy.aws_backend_api_gateway_cloudwatch_logs_policy.arn
}