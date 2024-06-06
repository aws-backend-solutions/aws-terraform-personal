resource "aws_kms_key" "aws_integration_tenant_mgmt_kms_key" {
  description             = "Symmetric key for encryption/decryption"
  deletion_window_in_days = 7
  tags = {
    Name = "${var.prefix_name}-kms-key"
    CostCenter  = "${var.cost_center_tag}"
    Environment = "${var.environment_tag}"
    Project     = "${var.project_tag}"
  }
}
