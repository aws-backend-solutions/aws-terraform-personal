resource "aws_api_gateway_rest_api" "primary_aws_integration_tenant_mgmt_api" {
  name          = "primary-${var.prefix_name}-api"
  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = [var.primary_aws_backend_vpc_endpoint_id]
  }

  tags = {
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
    Project     = var.project_tag
  }
}

resource "aws_api_gateway_rest_api_policy" "primary_api_gateway_policy" {
  rest_api_id = aws_api_gateway_rest_api.primary_aws_integration_tenant_mgmt_api.id

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