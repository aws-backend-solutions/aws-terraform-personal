resource "aws_lb" "primary_aws_backend_nlb" {
  name               = "${var.prefix_name}-nlb"
  internal           = true
  load_balancer_type = "network"
  security_groups    = [var.primary_aws_backend_security_group4_id]
  subnets            = var.primary_aws_backend_subnet_ids

  tags = {
    Name        = "${var.prefix_name}-nlb"
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_lb_target_group" "primary_aws_backend_tg" {
  name     = "${var.prefix_name}-tg"
  port     = 443
  protocol = "TCP"
  target_type = "ip"

  health_check {
    path                = "/${var.stage_name}/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    protocol            = "TCP"
  }

  vpc_id = var.primary_aws_backend_vpc_id
}

resource "aws_lb_target_group_attachment" "primary_aws_backend_nlb_attachment" {
  for_each = toset(var.primary_aws_backend_vpc_endpoint_ips)
  
  target_group_arn = aws_lb_target_group.primary_aws_backend_tg.arn
  target_id        = each.value
  port             = 443
}

resource "aws_lb_listener" "primary_aws_backend_nlb_listener" {
  load_balancer_arn = aws_lb.primary_aws_backend_nlb.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.primary_aws_backend_tg.arn
  }
}