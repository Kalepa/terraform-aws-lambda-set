variable "lambda_config" {
  description = "The Lambda function configuration. The variables are the same as the `aws_lambda_function` resource."
  type = object({
    function_name           = string
    role                    = optional(string)
    architectures           = optional(list(string))
    code_signing_config_arn = optional(string)
    dead_letter_config = optional(object({
      target_arn = string
    }))
    description = optional(string)
    environment = optional(object({
      variables = map(any)
    }))
    file_system_config = optional(object({
      arn              = string
      local_mount_path = string
    }))
    filename = optional(string)
    handler  = string
    image_config = optional(object({
      entry_point       = optional(string)
      command           = optional(string)
      working_directory = optional(string)
    }))
    image_uri                      = optional(string)
    kms_key_arn                    = optional(string)
    layers                         = optional(list(string))
    memory_size                    = optional(number)
    package_type                   = optional(string)
    publish                        = optional(bool)
    reserved_concurrent_executions = optional(number)
    runtime                        = optional(string)
    s3_bucket                      = optional(string)
    s3_key                         = optional(string)
    s3_object_version              = optional(string)
    source_code_hash               = optional(string)
    tags                           = optional(map(string))
    timeout                        = optional(number)
    tracing_config = optional(object({
      mode = string
    }))
    vpc_config = optional(object({
      subnet_ids         = list(string)
      security_group_ids = list(string)
    }))
  })
}

variable "edge" {
  description = "Whether this is a Lambda@Edge function."
  type        = bool
}

variable "source_directory" {
  description = "The directory that contains all files that must be bundled into the Lambda archive for upload. If this variable is provided, a ZIP archive of this directory will automatically be created and will be used for the Lambda. This variable conflicts with the `unzipped_source_file` variable and the `filename`, `s3_bucket`, `s3_key`, `s3_object_version`, `image_uri`, `package_type`, and `image_config` fields in the `lambda_config` variable."
  type        = string
  default     = null
}

variable "unzipped_source_file" {
  description = "A single source file in its unzipped state. If this variable is provided, a ZIP archive of this file will automatically be created and will be used for the Lambda. This variable conflicts with the `source_directory` variable and the `filename`, `s3_bucket`, `s3_key`, `s3_object_version`, `image_uri`, `package_type`, and `image_config` fields in the `lambda_config` variable."
  type        = string
  default     = null
}

variable "archive_output_directory" {
  description = "The directory where the Lambda archive should be saved. Only applies if the `source_directory` or `unzipped_source_file` variable is provided. Defaults to saving in the `path.module` directory (the path of this installed module)."
  type        = string
  default     = null
}

variable "archive_output_name" {
  description = "The filename to use for the Lambda archive. Only applies if the `source_directory` or `unzipped_source_file` variable is provided. Defaults to using the name of the directory or file being archived."
  type        = string
  default     = null
}

variable "role_policies" {
  description = "A list of policies (in JSON format) to attach to the role this Lambda uses for execution. This variable conflicts with the `role` field in the `lambda_config` variable (this module will not attach these policies to a provided role, as that should be done outside this module)."
  type        = list(string)
  default     = []
}

variable "role_policy_arns" {
  description = "A list of IAM policy ARNs to attach to the role this Lambda uses for execution. This variable conflicts with the `role` field in the `lambda_config` variable (this module will not attach these policies to a provided role, as that should be done outside this module)."
  type        = list(string)
  default     = []
}

variable "cloudwatch_logs_retention_days" {
  description = "The number of days to retain CloudWatch logs for this Lambda. Defaults to the account default."
  type        = number
  default     = null
}

variable "cloudwatch_logs_kms_key_id" {
  description = "The ID of the KMS key to use for encrypting the CloudWatch logs for this Lambda."
  type        = number
  default     = null
}

variable "add_vpc_access_to_role" {
  description = "Whether to add VPC access to the provided IAM role (only applies if both `role` and `vpc_config` values are provided in the `lambda_config` input)."
  type        = bool
  default     = false
}

variable "add_cloudwatch_logs_access_to_role" {
  description = "Whether to add write access to the CloudWatch Logs group to the provided IAM role (only applies if the `role` value was provided in the `lambda_config` input)."
  type        = bool
  default     = false
}

variable "execution_services" {
  description = "A list of service/ARN pairs that should be allowed to invoke this Lambda. The service must be specified, but the ARN can be omitted to allow invokations from all resources in that service."
  type = list(object({
    service = string
    arn     = optional(string)
  }))
  default = []
}

variable "schedules" {
  description = "A map of schedules to run this Lambda on. Keys are the schedule display names (must match the regex `[\\.\\-_A-Za-z0-9]+$`), values are maps with `schedule_expression` (e.g. \"rate(5 minutes)\"), `input` (the input that goes to the Lambda function), and `description`."
  type = map(object({
    schedule_expression = string
    input               = optional(string)
    description         = optional(string)
  }))
  default = {}
}

variable "logs_lambda_subscriptions" {
  description = "A list of configurations for Lambda subscriptions to the CloudWatch Logs Group for this Lambda. Each element should be a map with `destination_arn` (required), `name` (optional), `filter_pattern` (optional), and `distribution` (optional)."
  type = list(object({
    destination_arn = string
    name            = optional(string)
    filter_pattern  = optional(string)
    distribution    = optional(string)
  }))
  default = []
}

variable "logs_non_lambda_subscriptions" {
  description = "A list of configurations for non-Lambda subscriptions to the CloudWatch Logs Group for this Lambda. Each element should be a map with `destination_arn` (required), `name` (optional), `filter_pattern` (optional), `role_arn` (optional), and `distribution` (optional)."
  type = list(object({
    destination_arn = string
    name            = optional(string)
    filter_pattern  = optional(string)
    role_arn        = optional(string)
    distribution    = optional(string)
  }))
  default = []
}

variable "retries" {
  description = "A configuration for lambda asynchronous invocation retries."
  type = object({
    attempts                 = number
    max_event_age_in_seconds = number
  })
  default = null
}
