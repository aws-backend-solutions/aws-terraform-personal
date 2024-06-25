output "aws_integration_tenant_mgmt_sqs_queue_arn" {
  description = "The SQS Queue ARN for the primary API Gateway of primary_aws_integration_tenant_mgmt_api."
  value       = aws_sqs_queue.aws_integration_tenant_mgmt_sqs_queue.arn
}