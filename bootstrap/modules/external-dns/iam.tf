resource "aws_iam_access_key" "externaldns" {
  user = aws_iam_user.externaldns.name
}

#tfsec:ignore:aws-iam-no-user-attached-policies
resource "aws_iam_user" "externaldns" {
  name = "externaldns-${var.cluster_name}-cluster"
  path = "/automation/incluster/"
}

data "aws_route53_zone" "this" {
  name = var.dns_managed_zone
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
        "arn:aws:route53:::hostedzone/${data.aws_route53_zone.this.zone_id}"
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
