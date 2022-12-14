resource "aws_iam_access_key" "externalsecrets" {
  user    = aws_iam_user.externalsecrets.name
}

#tfsec:ignore:aws-iam-no-user-attached-policies
resource "aws_iam_user" "externalsecrets" {
  name = "${var.cluster_name}_cluster_secrets_user"
  path = "/externalsecrets/"
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
        "arn:aws:secretsmanager:eu-central-1:571075516563:secret:kaas/k8s/shared-secrets/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "assume_role" {
  name = "${var.cluster_name}_cluster_secrets_user"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
      "Sid": "Statement1",
      "Effect": "Allow",
      "Principal": {
          "AWS": "arn:aws:iam::571075516563:user/externalsecrets/${var.cluster_name}_cluster_secrets_user"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
