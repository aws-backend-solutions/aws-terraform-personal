output "primary_aws_backend_nlb_dns" {
  description = "DNS name of primary_aws_backend_nlb."
  value = aws_lb.primary_aws_backend_nlb.dns_name
}