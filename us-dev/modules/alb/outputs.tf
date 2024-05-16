output "aws_backend_load_balancer_arn" {
  description = "The ARN of the Load Balancer."
  value       = aws_lb.aws_backend_load_balancer.arn
}

output "aws_backend_load_balancer_dns_name" {
  description = "The URI of the Load Balancer."
  value       = aws_lb.aws_backend_load_balancer.dns_name
}

output "aws_backend_load_balancer_name" {
  description = "The name of the Load Balancer."
  value       = aws_lb.aws_backend_load_balancer.name
}

output "aws_backend_load_balancer_listener_80_id" {
  description = "The ID of the Load Balancer Listener."
  value       = aws_lb_listener.aws_backend_load_balancer_listener_80.id
}

output "aws_backend_load_balancer_listener_80_arn" {
  description = "The ARN of the Load Balancer Listener."
  value       = aws_lb_listener.aws_backend_load_balancer_listener_80.arn
}

output "aws_backend_load_balancer_listener_443_id" {
  description = "The ID of the Load Balancer Listener."
  value       = aws_lb_listener.aws_backend_load_balancer_listener_443.id
}

output "aws_backend_load_balancer_listener_443_arn" {
  description = "The ARN of the Load Balancer Listener."
  value       = aws_lb_listener.aws_backend_load_balancer_listener_443.arn
}