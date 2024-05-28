resource "aws_iam_service_linked_role" "aws_backend_api_gateway_role" {
  aws_service_name = "apigateway.amazonaws.com"
}
