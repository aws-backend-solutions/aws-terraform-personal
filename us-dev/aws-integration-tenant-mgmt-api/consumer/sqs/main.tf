resource "aws_sqs_queue" "aws_integration_tenant_mgmt_sqs_queue" {
  name          = "${var.prefix_name}-sqs-queue"
  visibility_timeout_seconds= 60 
  delay_seconds             = 0
}