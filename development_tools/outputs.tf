output "repository_id" {
  value       = aws_codecommit_repository.test.repository_id
  description = "The id of the repository"
}

output "repository_arn" {
  value       = aws_codecommit_repository.test.arn
  description = "The ARN for the repository"
}

output "clone_ssh_url" {
  value       = aws_codecommit_repository.test.clone_url_ssh
  description = "The clone URL using SSH"
}

output "clone_https_url" {
  value       = aws_codecommit_repository.test.clone_url_http
  description = "The clone URL using HTTPS"
}

output "sns_arn" {
  value       = aws_sns_topic.test.arn
  description = "The SNS ARN id"
}

output "trigger_name" {
  value       = aws_codecommit_trigger.test.configuration_id
  description = "The unique identifier for CodeCommit Repository Trigger"
}
