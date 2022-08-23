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
