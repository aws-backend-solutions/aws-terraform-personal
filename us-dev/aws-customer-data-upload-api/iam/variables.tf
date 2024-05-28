variable "prefix_name" {
  type = string
}

variable "aws_customer_data_upload_bucket_name" {
  type = string
  description = "The name of the designated s3 bucket for customers' data."
}

variable "aws_backend_api_gateway_role_name" {
  type = string
  description = "The name of the aws_backend_api_gateway_role."
}