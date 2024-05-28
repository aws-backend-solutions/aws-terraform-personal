resource "aws_iam_policy" "aws_customer_data_upload_s3_access_policy" {
  name        = "${var.prefix_name}-s3-access-policy"
  description = "Allows API Gateway to access S3 bucket"
  
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::${var.aws_customer_data_upload_bucket_name}/*"
      ]
    }
  ]
}
EOF
}

# Attach IAM policy to the API Gateway role
resource "aws_iam_role_policy_attachment" "aws_customer_data_upload_s3_access_attachment" {
  role       = var.aws_backend_api_gateway_role_name
  policy_arn = aws_iam_policy.aws_customer_data_upload_s3_access_policy.arn
}