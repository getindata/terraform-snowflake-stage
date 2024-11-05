variable "name" {
  description = "Name of the resource"
  type        = string
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
    name_scheme = optional(object({
      properties            = optional(list(string))
      delimiter             = optional(string)
      context_template_name = optional(string)
      replace_chars_regex   = optional(string)
      extra_labels          = optional(map(string))
    }))
    comment                   = optional(string)
    with_grant_option         = optional(bool)
    granted_to_roles          = optional(list(string))
    granted_to_database_roles = optional(list(string))
    granted_database_roles    = optional(list(string))
    stage_grants              = optional(list(string))
    all_privileges            = optional(bool)
  }))
  default = {}
}

variable "stage_ownership_grant" {
  description = "To which account role the stage ownership should be granted"
  type        = string
  default     = null
}

variable "name_scheme" {
  description = <<EOT
  Naming scheme configuration for the resource. This configuration is used to generate names using context provider:
    - `properties` - list of properties to use when creating the name - is superseded by `var.context_templates`
    - `delimiter` - delimited used to create the name from `properties` - is superseded by `var.context_templates`
    - `context_template_name` - name of the context template used to create the name
    - `replace_chars_regex` - regex to use for replacing characters in property-values created by the provider - any characters that match the regex will be removed from the name
    - `extra_values` - map of extra label-value pairs, used to create a name
  EOT
  type = object({
    properties            = optional(list(string), ["name"])
    delimiter             = optional(string, "_")
    context_template_name = optional(string, "snowflake-stage")
    replace_chars_regex   = optional(string, "[^a-zA-Z0-9_]")
    extra_values          = optional(map(string))
  })
  default = {}
}

variable "context_templates" {
  description = "Map of context templates used for naming conventions - this variable supersedes `naming_scheme.properties` and `naming_scheme.delimiter` configuration"
  type        = map(string)
  default     = {}
}
