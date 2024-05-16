resource "aws_lb" "aws_backend_load_balancer" {
  name               = "aws-backend-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = [
    var.aws_backend_private_subnet1_id,
    var.aws_backend_private_subnet2_id,
    var.aws_backend_public_subnet1_id,
    var.aws_backend_public_subnet2_id
  ]
  tags = {
    Name        = "aws-backend-nlb"
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}

# Target Group for port 80
resource "aws_lb_target_group" "aws_backend_target_group_80" {
  name     = "aws-backend-target-group-80"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.aws_backend_vpc_id

  health_check {
    protocol            = "TCP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Target Group for port 443
resource "aws_lb_target_group" "aws_backend_target_group_443" {
  name     = "aws-backend-target-group-443"
  port     = 443
  protocol = "TCP"
  vpc_id   = var.aws_backend_vpc_id

  health_check {
    protocol            = "TCP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Listener for port 80
resource "aws_lb_listener" "aws_backend_load_balancer_listener_80" {
  load_balancer_arn = aws_lb.aws_backend_load_balancer.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_backend_target_group_80.arn
  }
}

# Listener for port 443
resource "aws_lb_listener" "aws_backend_load_balancer_listener_443" {
  load_balancer_arn = aws_lb.aws_backend_load_balancer.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_backend_target_group_443.arn
  }
}
