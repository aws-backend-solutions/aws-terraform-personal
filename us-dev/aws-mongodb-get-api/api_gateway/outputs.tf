output "aws_mongodb_ga_api_id" {
  description = "ID for aws-mongodb-ga-api"
  value = aws_api_gateway_rest_api.aws_mongodb_ga_api.id
}