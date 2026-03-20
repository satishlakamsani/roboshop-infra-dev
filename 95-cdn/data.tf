data "aws_cloudfront_cache_policy" "cachingDisabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "cachingOptmized"{
    name = "Managed-CachingOptimized"
}
data "aws_ssm_parameter" "acm_certificate_arn"{

  name = "/${var.project}/${var.environment}/frontend_alb_certificate_arn"

}
