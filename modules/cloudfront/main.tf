module "cdn" {
  source                        = "terraform-aws-modules/cloudfront/aws"
  comment                       = "My awesome CloudFront"
  enabled                       = true
  is_ipv6_enabled               = true
  price_class                   = "PriceClass_All"
  retain_on_delete              = false
  wait_for_deployment           = false
  default_root_object           = var.home_page
  create_origin_access_identity = false
  create_origin_access_control  = true
  origin_access_control = {
    "${var.enviorment}_margisha" = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }
  origin = {
    "${var.enviorment}_margisha" = {
      domain_name           = data.aws_s3_bucket.bucket.bucket_regional_domain_name
      origin_access_control = "${var.enviorment}_margisha"
    }

    db = {
      domain_name = "${var.api_id}.execute-api.${data.aws_region.current.name}.amazonaws.com"
      # origin_path = "/prod"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
      custom_header = [
        {
          name  = "X-API-KEY"
          value = var.api_key
        }
      ]
    }
  }
  ordered_cache_behavior = [{
    path_pattern           = "/prod/deployment"
    target_origin_id       = "db"
    viewer_protocol_policy = "https-only"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    use_forwarded_values   = true
  }]

  default_cache_behavior = {
    target_origin_id       = "${var.enviorment}_margisha"
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    use_forwarded_values   = true
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values = {
      query_string = false
      headers      = ["Origin"]

      cookies = {
        forward = "none"
      }
    }
    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
    compress    = true
  }
  custom_error_response = {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 200
    response_page_path    = "/frontend/403.html"
  }
  tags = {
    Environment = "${var.enviorment}"
    Deployed_By = "V2solutions"
  }

}



data "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

data "aws_region" "current" {}