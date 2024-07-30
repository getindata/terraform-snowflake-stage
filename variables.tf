variable "descriptor_name" {
  description = "Name of the descriptor used to form a resource name"
  type        = string
  default     = "snowflake-stage"
}

variable "database" {
  description = "The database in which to create the stage"
  type        = string
}

variable "schema" {
  description = "The schema in which to create the stage"
  type        = string
}

variable "aws_external_id" {
  description = "ID of the customer AWS account"
  type        = string
  default     = null
}

variable "comment" {
  description = "Specifies a comment for the stage"
  type        = string
  default     = null
}

variable "copy_options" {
  description = "Specifies the copy options for the stage"
  type        = string
  default     = null
}

variable "credentials" {
  description = "Specifies the credentials for the stage"
  type        = string
  default     = null
}

variable "directory" {
  description = "Specifies the directory settings for the stage"
  type        = string
  default     = null
}

variable "encryption" {
  description = "Specifies the encryption settings for the stage"
  type        = string
  default     = null
}

variable "file_format" {
  description = "Specifies the file format for the stage"
  type        = string
  default     = null
}

variable "snowflake_iam_user" {
  description = "Specifies the Snowflake IAM user"
  type        = string
  default     = null
}

variable "storage_integration" {
  description = "Specifies the name of the storage integration used to delegate authentication responsibility for external cloud storage to a Snowflake identity and access management (IAM) entity"
  type        = string
  default     = null
}

variable "url" {
  description = "Specifies the URL for the stage"
  type        = string
  default     = null
}

variable "create_default_roles" {
  description = "Whether the default database roles should be created"
  type        = bool
  default     = false
}

variable "roles" {
  description = "Database roles created in the stage scope"
  type = map(object({
    enabled                   = optional(bool, true)
    with_grant_option         = optional(bool)
    granted_to_roles          = optional(list(string))
    granted_to_database_roles = optional(list(string))
    granted_database_roles    = optional(list(string))
    stage_grants              = optional(list(string))
    all_privileges            = optional(bool)
    on_all                    = optional(bool, false)
    schema_name               = optional(string)
    on_future                 = optional(bool, false)
  }))
  default = {}
}

variable "stage_ownership_grant" {
  description = "To which role the stage ownership should be granted"
  type        = string
  default     = null
}
