data "aws_caller_identity" "current" {}

resource "aws_iam_access_key" "externalsecrets" {
  user = aws_iam_user.externalsecrets.name
}

#tfsec:ignore:aws-iam-no-user-attached-policies
resource "aws_iam_user" "externalsecrets" {
  name = "externalsecrets-${var.cluster_name}-cluster"
  path = "/automation/incluster/"
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "externalsecrets" {
  name = "${var.cluster_name}_cluster_ssm_policy"
  role = aws_iam_role.assume_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
      ],
      "Resource": [
        "arn:aws:secretsmanager:eu-central-1:${data.aws_caller_identity.current.account_id}:secret:kaas/clusterwide-sharedsecrets/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "assume_role" {
  name               = "externalsecrets-${var.cluster_name}-cluster"
  path               = "/automation/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
      "Sid": "Statement1",
      "Effect": "Allow",
      "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/automation/incluster/externalsecrets-${var.cluster_name}-cluster"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
