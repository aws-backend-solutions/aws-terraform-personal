output "aws_integration_tenant_mgmt_kms_arn" {
  description = "The ARN of the KMS key created for this project."
  value       = aws_kms_key.aws_integration_tenant_mgmt_kms_key.arn
}

output "aws_integration_tenant_mgmt_kms_key_id" {
  description = "The ID of the KMS key created for this project."
  value       = aws_kms_key.aws_integration_tenant_mgmt_kms_key.id
}