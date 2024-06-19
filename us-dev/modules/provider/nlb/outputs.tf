output "aws_backend_nlb_dns_name" {
  description = "DNS name of aws_backend_nlb."
  value       = aws_lb.aws_backend_nlb.dns_name
}

output "aws_backend_nlb_arn" {
  description = "ARN of aws_backend_nlb."
  value       = aws_lb.aws_backend_nlb.arn
}