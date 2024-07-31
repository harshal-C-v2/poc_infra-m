
data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "allow_cloudfront_access" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${module.cdn.cloudfront_distribution_id}"
      ]
    }
  }
}


resource "aws_s3_bucket_policy" "this" {
  depends_on = [module.cdn]
  bucket     = var.bucket_name
  policy     = data.aws_iam_policy_document.allow_cloudfront_access.json
}