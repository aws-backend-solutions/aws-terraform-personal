resource "aws_s3_bucket" "aws_customer_data_upload_bucket" {
  bucket = "${var.prefix_name}-bucket"
  
  tags = {
    Name        = "${var.prefix_name}-bucket"
    CostCenter  = var.cost_center_tag
    Environment = var.environment_tag
    Project     = var.project_tag
  }
}

resource "aws_s3_bucket_versioning" "aws_customer_data_upload_bucket_versioning" {
  bucket = aws_s3_bucket.aws_customer_data_upload_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "aws_customer_data_upload_bucket_policy" {
  bucket = aws_s3_bucket.aws_customer_data_upload_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}