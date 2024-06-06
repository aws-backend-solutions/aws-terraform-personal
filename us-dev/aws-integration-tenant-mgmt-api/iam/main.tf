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
        "Resource" : "${var.aws_integration_tenant_mgmt_kms_arn}"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "aws_integration_tenant_mgmt_kms_policy_attachment" {
  name       = "${var.prefix_name}-kms-policy-attachment"
  roles      = [aws_iam_role.aws_integration_tenant_mgmt_kms_role.name]
  policy_arn = aws_iam_policy.aws_integration_tenant_mgmt_kms_policy.arn
}

resource "aws_kms_grant" "aws_integration_tenant_mgmt_kms_grant" {
  name = "${var.prefix_name}-kms-grant"
  key_id            = "${var.aws_integration_tenant_mgmt_kms_key_id}"
  grantee_principal = aws_iam_role.aws_integration_tenant_mgmt_kms_role.arn
  operations        = ["Encrypt", "Decrypt"]
}