output "bucket_name" {
  value = aws_s3_bucket.this.id
}

output "arn" {
  value = aws_s3_bucket.this.arn
}

output "hosted_zone_id" {
  value = aws_s3_bucket.this.hosted_zone_id
}

output "website_domain" {
  value = try(aws_s3_bucket_website_configuration.this[0].website_domain, null)
}



