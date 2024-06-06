data "aws_caller_identity" "current" {}

resource "aws_kms_key" "aws_integration_tenant_mgmt_kms_key" {
  description             = "Symmetric key for encryption/decryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  depends_on = [ aws_iam_role.aws_integration_tenant_mgmt_kms_role ]

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id": "key-default-1",
    "Statement" : [
      {
        "Sid": "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid": "Allow use of the key",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : aws_iam_role.aws_integration_tenant_mgmt_kms_role.arn
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      }
    ]
  })

  tags = {
    Name        = "${var.prefix_name}-kms-key"
    CostCenter  = "${var.cost_center_tag}"
    Environment = "${var.environment_tag}"
    Project     = "${var.project_tag}"
  }
}

resource "aws_kms_alias" "aws_integration_tenant_mgmt_kms_alias" {
  name          = "alias/${var.prefix_name}-kms-alias"
  target_key_id = aws_kms_key.aws_integration_tenant_mgmt_kms_key.id
}

resource "aws_iam_role" "aws_integration_tenant_mgmt_kms_role" {
  name = "${var.prefix_name}-kms-role"
  
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "aws_integration_tenant_mgmt_kms_policy" {
  name        = "${var.prefix_name}-kms-policy"
  description = "Policy for accessing KMS encryption/decryption"
  depends_on = [ aws_kms_key.aws_integration_tenant_mgmt_kms_key ]
  
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : aws_kms_key.aws_integration_tenant_mgmt_kms_key.arn
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "aws_integration_tenant_mgmt_kms_policy_attachment" {
  name       = "${var.prefix_name}-kms-policy-attachment"
  roles      = [aws_iam_role.aws_integration_tenant_mgmt_kms_role.name]
  policy_arn = aws_iam_policy.aws_integration_tenant_mgmt_kms_policy.arn
}
