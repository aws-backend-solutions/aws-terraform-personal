resource "aws_lb" "aws_backend_load_balancer" {
  name               = "${var.prefix_name}-lb"
  internal           = true
  security_groups    = [
    var.aws_backend_security_group1_id
    ]
  subnets            = [
    var.aws_backend_private_subnet1_id,
    var.aws_backend_private_subnet2_id,
    var.aws_backend_public_subnet1_id,
    var.aws_backend_public_subnet2_id,
  ]
  tags = {
    Name       = "${var.prefix_name}-lb"
    CostCenter = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_lb_listener" "aws_backend_load_balancer_listener" {
  load_balancer_arn = aws_lb.aws_backend_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type    = "application/json"
      status_code     = "404"
      message_body    = "The URL you requested could not be found."
    }
  }
}