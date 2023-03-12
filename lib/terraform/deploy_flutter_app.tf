# Log bucket
resource "aws_s3_bucket" "cloudfront_log_bucket" {
  bucket_prefix = "${local.name_with_env}-cf-logs-"
  acl           = "log-delivery-write"
}

# Web app bucket
module "web_app" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 2.0"

  bucket_prefix = "${local.name_with_env}-web-app-"
  force_destroy = true
}

# Origin Access Identities
data "aws_iam_policy_document" "s3_web_app_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.web_app.s3_bucket_arn}/*"]

    principals {
      type        = "AWS"
      identifiers = module.cloudfront.cloudfront_origin_access_identity_iam_arns
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.web_app.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_web_app_policy.json
}

# Request policy
resource "aws_cloudfront_origin_request_policy" "api_request_policy" {
  name = "${local.name_with_env}-api-request-policy"
  cookies_config {
    cookie_behavior = "all"
  }
  headers_config {
    header_behavior = "allViewer"
  }
  query_strings_config {
    query_string_behavior = "all"
  }
}

resource "aws_cloudfront_cache_policy" "api_cache_policy" {
  name        = "${local.name_with_env}-api-cache-policy"
  default_ttl = 0
  max_ttl     = 0
  min_ttl     = 0
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "2.9.2"

  comment             = "${local.name_with_env} distribution"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = true

  # These aliases can ONLY be on one CF distribution globally across all accounts.
  aliases = [
    var.domain_name,
    "www.${var.domain_name}",
  ]

  create_origin_access_identity = true
  origin_access_identities = {
    web_app = "My web app"
  }

  logging_config = {
    bucket = aws_s3_bucket.cloudfront_log_bucket.bucket_domain_name
    prefix = var.domain_name
  }

  origin = {
    default = {
      domain_name = module.web_app.s3_bucket_bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "web_app" # key in `origin_access_identities`
      }
    }

    app_api = {
      # I'm pointing to Elastic Beanstalk here, but it could be ELB, API Gateway, etc.
      domain_name = module.elastic_beanstalk_environment.endpoint
      custom_origin_config = {
        http_port              = var.eb_api_port
        https_port             = var.eb_api_port
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  # Everything that doesn't match an ordered_cache_behavior goes here (i.e., your SPA requests).
  default_cache_behavior = {
    target_origin_id       = "default"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true

    function_association = {
      viewer-request = {
        function_arn = aws_cloudfront_function.web_app_url_rewriter_cf_function.arn
      }
    }
  }

  ordered_cache_behavior = [
    # REST or GraphQL API requests go here
    {
      path_pattern             = "/api/*"
      target_origin_id         = "app_api"
      viewer_protocol_policy   = "redirect-to-https"
      origin_request_policy_id = aws_cloudfront_origin_request_policy.api_request_policy.id
      cache_policy_id          = aws_cloudfront_cache_policy.api_cache_policy.id
      use_forwarded_values     = false

      allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true

      min_ttl     = 0
      max_ttl     = 0
      default_ttl = 0
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }
}

# Cloudfront function to rewrite '/' -> '/index.html'
resource "aws_cloudfront_function" "web_app_url_rewriter_cf_function" {
  name    = "${local.name_with_env}-web-app-url-rewriter"
  runtime = "cloudfront-js-1.0"
  code    = file("url_rewriter.js")
}
# rm -rf build/web
# flutter pub get
# flutter build web --release --web-renderer canvaskit

# dist_bucket=<your-bucket-name>
# # Clean out the bucket
# aws s3 rm s3://${dist_bucket} --recursive
# # Upload everything fresh
# aws s3 cp build/web/ s3://${dist_bucket} --recursive

# # Invalidate cloudfront to flush the edge node caches
# DISTRIBUTION_ID=`aws cloudfront list-distributions |
#   jq -r '.DistributionList.Items[] | select(.Comment == "myapp-prod distribution") | .Id'`
# aws cloudfront create-invalidation --distribution-id ${DISTRIBUTION_ID} --paths '/*'
