# Attention
# this file should only run for the initial project setup
# this will setup:
#   a s3 bucket for the tfstate
#   a iam user to manage the rest from github
#
# If you need to add policies to the github user, run this

provider "aws" {
  region  = "eu-central-1"
  profile = ""

  default_tags {
    tags = {
      setup   = "automation"
      service = "kaas"
      Owner   = "ops"
      Name    = "ops-k8s-bootstrap"
    }
  }
}

data "aws_caller_identity" "current" {}

#tfsec:ignore:aws-iam-no-user-attached-policies
resource "aws_iam_user" "ops_github_kaas" {
  name = "ops-github-kaas"
  path = "/automation/"
}

resource "aws_iam_user_policy" "iam_cluster_users" {
  name = "iam_cluster_users"
  user = aws_iam_user.ops_github_kaas.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = <<JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1667481895055",
            "Action": [
                "iam:CreateUser",
                "iam:ListGroupsForUser",
                "iam:Taguser",
                "iam:DeleteUser",
                "iam:PutUserPolicy",
                "iam:GetUser",
                "iam:GetUserPolicy",
                "iam:CreateAccessKey",
                "iam:ListAccessKeys"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/automation/incluster/*"
        }
    ]
}
JSON
}

resource "aws_iam_user_policy" "secretsmanager" {
  name = "secretsmanager"
  user = aws_iam_user.ops_github_kaas.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = <<JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1667997895963",
            "Action": [
                "secretsmanager:DescribeSecret",
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:secretsmanager:eu-central-1:${data.aws_caller_identity.current.account_id}:secret:kaas/*"
        }
    ]
}
JSON
}

resource "aws_iam_user_policy" "route53" {
  name = "route53"
  user = aws_iam_user.ops_github_kaas.id

  #tfsec:ignore:aws-iam-no-policy-wildcards
  policy = <<JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1667997895964",
            "Action": [
                "route53:GetHostedZone",
                "route53:ListHostedZones",
                "route53:ListTagsForResource"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
JSON
}

resource "aws_iam_user_policy" "iam_role" {
  name = "iam_cluster_role"
  user = aws_iam_user.ops_github_kaas.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = <<JSON
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1667481895059",
            "Action": [
                "iam:CreateRole",
                "iam:TagRole",
                "iam:GetRole",
                "iam:ListRolePolicies",
                "iam:ListAttachedRolePolicies",
                "iam:ListInstanceProfilesForRole",
                "iam:DeleteRole",
                "iam:PutRolePolicy",
                "iam:GetRolePolicy",
                "iam:DeleteRolePolicy"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/automation/*"
        }
    ]
}
JSON
}

resource "aws_iam_access_key" "github" {
  user = aws_iam_user.ops_github_kaas.name
}

#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "tfstate" {
  bucket = "ops-kaas-tfstate"
}

resource "aws_s3_bucket_acl" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_github_user" {
  bucket = aws_s3_bucket.tfstate.id
  policy = <<JSON
{
  "Id": "Policy1666800308880",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1666800306128",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutBucketVersioning",
        "s3:PutEncryptionConfiguration",
        "s3:PutObject",
        "s3:GetBucketVersioning",
        "s3:GetEncryptionConfiguration",
        "s3:GetBucketPublicAccessBlock",
        "s3:PutBucketPublicAccessBlock"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::ops-kaas-tfstate",
        "arn:aws:s3:::ops-kaas-tfstate/*"
      ],
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/automation/${aws_iam_user.ops_github_kaas.name}"
        ]
      }
    }
  ]
}
JSON
}

output "github_access_key" {
  value = aws_iam_access_key.github.id
}
output "github_secret_key" {
  value     = aws_iam_access_key.github.secret
  sensitive = true
}
