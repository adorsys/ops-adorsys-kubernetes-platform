resource "aws_iam_user" "externaldns" {
  name = "${cluster_name}_cluster_dns_user"
  path = "/externaldns/"
}

resource "aws_iam_user_policy" "externaldns" {
  name = "${cluster_name}_cluster_dns_policy"
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
        "arn:aws:route53:::adorsys.io/*"
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