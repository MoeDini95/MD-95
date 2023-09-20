// Provider configuration
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "KingDini"
}


resource "aws_s3_bucket" "bucket" {
  bucket = "mdresume.com"

}

# Upload website files to S3: 
resource "aws_s3_object" "html" {
  bucket = "mdresume.com"
  for_each = fileset("/Users/dini/MD-95","*")
  key = "index.html"
  source = "/Users/dini/MD-95/Frontend/index.html"
  content_type = "text/html"
  
}

resource "aws_s3_object" "css" {
  bucket = "mdresume.com"
  for_each = fileset("/Users/dini/MD-95","*")
  key = "style.css"
  source = "/Users/dini/MD-95/Frontend/style.css"
  content_type = "text/css"
  
}

resource "aws_s3_object" "js" {
  bucket = "mdresume.com"
  for_each = fileset("/Users/dini/MD-95","*")
  key = "index.js"
  source = "/Users/dini/MD-95/Frontend/index.js"
  content_type = "text/js"
  
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = "mdresume.com"

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_website_configuration" "bucket" {
  bucket = "mdresume.com"
  index_document {
    suffix = "index.html"
  }
 
    error_document {
      key = "error.html"
    }
}

resource "aws_s3_bucket_policy" "my_aws_s3_bucket" {
  bucket = "mdresume.com"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::mdresume.com/*"
      }
    ]
  })
}


### CloudFront Config

resource "aws_cloudfront_distribution" "distribution" {

  origin {
    domain_name = "md-95.com"
    origin_id = "mdresume.com"
  }
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"




  default_cache_behavior {
      target_origin_id           = "something"
      viewer_protocol_policy     = "allow-all"

      allowed_methods = ["GET", "HEAD"]
      cached_methods  = ["GET", "HEAD"]
  
  }

    viewer_certificate  {
    acm_certificate_arn = "arn:aws:acm:us-east-1:259004904941:certificate/48121352-a0e6-4fdb-a0bd-9f4effa61516"
    ssl_support_method  = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      
    }
  }


### Route 53 Config

}

  resource "aws_route53_record" "www" {
    zone_id = "Z00320042SQ1XLFPNWUT"
    name = "md-95.com"
    type = "A"

    alias {
      name        = "md-95.com"
      zone_id = "Z00320042SQ1XLFPNWUT"
      evaluate_target_health = false
    }
    
  }

  resource "aws_route53_record" "ns" {
    allow_overwrite = true
    name = "md-95.com"
    ttl = 120
    type = "NS"
    zone_id = "Z00320042SQ1XLFPNWUT"

    records = [
      "ns-839.awsdns-40.net",
      "ns-1059.awsdns-04.org",
      "ns-1.awsdns-00.com",
      "ns-1854.awsdns-39.co.uk",
    ]

  }

  









