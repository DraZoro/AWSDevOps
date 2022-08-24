variable "repository_name" {
  type        = string
  default     = "my-webpage"
  description = "The repository name"
}

variable "repository_description" {
  type        = string
  default     = "A basic repository for testing purpose"
  description = "Use to give small notes about the Code Commit repository"
}

variable "codecommit_tags" {
  type = map(string)
  default = {
    Environment = "Test"
    Department  = "Training"

  }
  description = "The list of tags for the repository"
}

variable "topic_name" {
  type        = string
  default     = "CodeCommitNotification"
  description = "The SNS topic name"
}

variable "trigger_name" {
  type        = string
  default     = "TestTrigger"
  description = "The trigger name for CodeCommit Repository"
}

variable "topic_tags" {
  type = map(string)
  default = {
    Environment = "Test"
    Department  = "Training"

  }
  description = "The list of tags for the SNS topic"
}