output "id" {
  description = "The policy's ID"
  value       = try(aws_iam_policy.policy.id, "")
}

output "arn" {
  description = "The ARN assigned by AWS to this policy"
  value       = try(aws_iam_policy.policy.arn, "")
}

output "description" {
  description = "The description of the policy"
  value       = try(aws_iam_policy.policy.description, "")
}

output "name" {
  description = "The name of the policy"
  value       = try(aws_iam_policy.policy.name, "")
}

output "path" {
  description = "The path of the policy in IAM"
  value       = try(aws_iam_policy.policy.path, "")
}

output "policy" {
  description = "The policy document"
  value       = try(aws_iam_policy.policy.policy, "")
}