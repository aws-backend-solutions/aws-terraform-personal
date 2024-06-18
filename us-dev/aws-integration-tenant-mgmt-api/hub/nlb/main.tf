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

resource "aws_lb_target_group" "primary_aws_integration_tenant_mgmt_tg" {
  name     = "${var.prefix_name}-tg"
  port     = 443
  protocol = "TLS"

  health_check {
    path                = "/ping"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  vpc_id = var.primary_aws_backend_vpc_id
}

resource "aws_lb_target_group_attachment" "primary_aws_integration_tenant_mgmt_nlb_attachment" {
  target_group_arn = aws_lb_target_group.primary_aws_integration_tenant_mgmt_tg.arn
  target_id        = var.primary_aws_backend_vpc_endpoint_dns
}
