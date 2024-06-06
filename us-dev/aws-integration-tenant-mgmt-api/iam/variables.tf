variable "prefix_name" {
  type = string
}

variable "aws_integration_tenant_mgmt_kms_arn" {
  type        = string
  description = "The ARN of the KMS key created for this project."
}

variable "aws_integration_tenant_mgmt_kms_key_id" {
  type        = string
  description = "The ID of the KMS key created for this project."
}
