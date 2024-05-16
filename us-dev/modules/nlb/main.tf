resource "aws_lb" "aws_backend_load_balancer" {
  name        = "aws-backend-nlb"
  internal    = true
  load_balancer_type = "network"
  subnets     = [
    var.aws_backend_private_subnet1_id,
    var.aws_backend_private_subnet2_id
  ]
  tags = {
    Name        = "aws-backend-nlb"
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
  }
}

resource "aws_lb_listener" "aws_backend_load_balancer_listener" {
  load_balancer_arn = aws_lb.aws_backend_load_balancer.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type    = "application/json"
      status_code     = "404"
      message_body    = "The URL you requested could not be found."
    }
  }
}
