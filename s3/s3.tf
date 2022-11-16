resource "aws_s3_bucket" "this" {
  bucket = var.name
  tags   = var.tags
}



# bucket ownership
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  # Access Control List
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy

  # Bucket Policy ( public access )
  restrict_public_buckets = var.restrict_public_buckets
  ignore_public_acls      = var.ignore_public_acls
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.aws_s3_bucket_policy == null ? 0 : 1
  bucket = aws_s3_bucket.this.id
  policy = var.aws_s3_bucket_policy
}

# web hosting
resource "aws_s3_bucket_website_configuration" "this" {
  count = var.website_yn == true ? 1 : 0

  bucket = aws_s3_bucket.this.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}