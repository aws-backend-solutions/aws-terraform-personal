resource "aws_lb" "primary_aws_integration_tenant_mgmt_nlb" {
  name               = "${var.prefix_name}-nlb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [var.primary_aws_backend_security_group4_id]
  subnets            = var.primary_aws_backend_subnet_ids

  tags = {
    Name        = "${var.prefix_name}-nlb"
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}
