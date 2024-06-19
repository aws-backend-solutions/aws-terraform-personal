resource "aws_lb" "aws_backend_nlb" {
  name               = "${var.prefix_name}-nlb"
  internal           = true
  load_balancer_type = "network"
  security_groups    = [var.aws_backend_security_group4_id]
  subnets            = var.aws_backend_subnet_ids

  tags = {
    Name        = "${var.prefix_name}-nlb"
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_lb_target_group" "aws_backend_nlb_tg" {
  name     = "${var.prefix_name}-nlb-tg"
  port     = 443
  protocol = "TCP"
  target_type = "ip"

  # health_check {
  #   path                = "/${var.stage_name}/health"
  #   interval            = 30
  #   timeout             = 5
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 2
  #   protocol            = "HTTPS"
  # }

  vpc_id = var.aws_backend_vpc_id
}

resource "aws_lb_target_group_attachment" "aws_backend_nlb_attachment" {
  for_each = toset(var.aws_backend_vpc_endpoint_ips)
  
  target_group_arn = aws_lb_target_group.aws_backend_nlb_tg.arn
  target_id        = each.value
  port             = 443
}

resource "aws_lb_listener" "aws_backend_nlb_listener" {
  load_balancer_arn = aws_lb.aws_backend_nlb.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_backend_nlb_tg.arn
  }
}