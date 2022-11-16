resource "aws_lambda_function" "this" {    
  description = var.description
  function_name = var.function_name
  # filename = "${data.archive_file.this.output_path}"  
  filename = var.zip_yn ? "${var.path}/zip/source.zip" : null
  source_code_hash = var.zip_yn ? "${data.archive_file.this[0].output_base64sha256}" : null
  role = var.role
  handler = var.handler
  runtime = var.runtime
  memory_size = var.memory_size
  timeout = var.timeout

  image_uri = var.image_yn ? var.image_uri : null
  package_type = var.package_type

  dynamic "vpc_config" {
    
    for_each = var.vpc_yn  ? toset([1]) : toset([])      

    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }  
  
  dynamic "environment" {
    for_each = var.environment

    content {
      variables = environment.value
    }
  }

 
  lifecycle {
    ignore_changes = [
      handler,
      runtime
    ]
  }

  tags = var.tags  
}


resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.retention_in_days
}

data "archive_file" "this" {
  count = var.zip_yn ? 1 : 0
  type        = "zip"
  # source_file = "${var.path}"
  source_dir = "${var.path}/src"
  output_path = "${var.path}/zip/source.zip"  
}