resource "aws_iam_access_key" "externaldns" {
  user = aws_iam_user.externaldns.name
}

#tfsec:ignore:aws-iam-no-user-attached-policies
resource "aws_iam_user" "externaldns" {
  name = "externaldns-${var.cluster_name}-cluster"
  path = "/automation/incluster/"
}

data "aws_route53_zone" "this" {
  for_each = toset(var.dns_managed_zones)
  name     = each.key
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_user_policy" "externaldns" {
  name = "${var.cluster_name}_cluster_dns_policy_${each.key}"
  user = aws_iam_user.externaldns.name

  for_each = toset(var.dns_managed_zones)

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
        "arn:aws:route53:::hostedzone/${data.aws_route53_zone.this[each.key].zone_id}"
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
