variable "name" {
  type = string
}

variable "block_public_acls" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}

variable "ignore_public_acls" {
  type    = bool
  default = true
}


variable "aws_s3_bucket_policy" {
  type    = string
  default = null
}

variable "website_yn" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(any)
  default = {}
}