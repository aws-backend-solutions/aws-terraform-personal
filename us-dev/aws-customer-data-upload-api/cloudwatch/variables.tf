variable "prefix_name" {
  type = string
}

variable "cost_center_tag" {
  type        = string
  description = "Used for tagging the resources created."
  default     = "AWSDevAccount"
}

variable "environment_tag" {
  type        = string
  description = "Provide which environment this will be deployed. Used for tagging the resources created."
}

variable "project_tag" {
  type        = string
  description = "Provide the repository name. Used for tagging the resources created."
}

variable "cloudwatch_alarm_topic_arn" {
  type        = string
  description = "The ARN of cloudwatch_alarms_topic."
}

variable "new_function_name" {
  type        = string
  description = "Lambda's function name (Upload and generate new url)."
}

variable "renew_function_name" {
  type        = string
  description = "Lambda's function name (Regenerate new url)."
}