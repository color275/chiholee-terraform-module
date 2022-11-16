resource "aws_ssm_parameter" "secret" {
  count             = length(var.parameter_list)
  name        = var.parameter_list[count.index][0]
  value       = var.parameter_list[count.index][1]
  description = var.parameter_list[count.index][2]
  type        = "SecureString"
  key_id = var.kms_key_id
}