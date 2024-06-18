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

variable "recipient_for_budgets" {
  type        = string
  description = "The recipient of the budget alerts when the threshold exceeds."
}

variable "recipient_for_cloudwatch" {
  type        = string
  description = "The recipient of the cloudwatch alarms when there is an error."
}