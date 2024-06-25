resource "aws_sqs_queue" "aws_integration_tenant_mgmt_sqs_queue" {
  name          = "${var.prefix_name}-sqs-queue"
  delay_seconds = 10
}