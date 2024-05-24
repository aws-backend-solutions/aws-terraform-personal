output "aws_customer_data_upload_bucket_arn" {
  description = "The ARN of the designated s3 bucket for customers' data."
  value = aws_s3_bucket.aws_customer_data_upload_bucket.arn
}