output "primary_aws_integration_tenant_mgmt_nlb_dns" {
  description = "DNS name of primary_aws_integration_tenant_mgmt_nlb."
  value = aws_lb.primary_aws_integration_tenant_mgmt_nlb.dns_name
}