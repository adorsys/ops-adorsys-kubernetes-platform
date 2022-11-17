resource "aws_iam_access_key" "externaldns" {
  user    = aws_iam_user.externaldns.name
}

#tfsec:ignore:aws-iam-no-user-attached-policies
resource "aws_iam_user" "externaldns" {
  name = "${var.cluster_name}_cluster_dns_user"
  path = "/externaldns/"
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_user_policy" "externaldns" {
  name = "${var.cluster_name}_cluster_dns_policy"
  user = aws_iam_user.externaldns.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/Z01771591GBUB3YYNQKTI"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}