data "context_label" "this" {
  delimiter  = local.context_template == null ? var.name_scheme.delimiter : null
  properties = local.context_template == null ? var.name_scheme.properties : null
  template   = local.context_template

  replace_chars_regex = var.name_scheme.replace_chars_regex

  values = merge(
    var.name_scheme.extra_values,
    { name = var.name }
  )
}

resource "snowflake_stage" "this" {
  name     = data.context_label.this.rendered
  database = var.database
  schema   = var.schema

  aws_external_id     = var.aws_external_id
  comment             = var.comment
  copy_options        = var.copy_options
  credentials         = var.credentials
  directory           = var.directory
  encryption          = var.encryption
  file_format         = var.file_format
  snowflake_iam_user  = var.snowflake_iam_user
  storage_integration = var.storage_integration
  url                 = var.url
}
moved {
  from = snowflake_stage.this[0]
  to   = snowflake_stage.this
}

resource "snowflake_grant_ownership" "stage_ownership" {
  count = var.stage_ownership_grant != null ? 1 : 0

  account_role_name   = var.stage_ownership_grant
  outbound_privileges = "REVOKE"
  on {
    object_type = "STAGE"
    object_name = snowflake_stage.this.fully_qualified_name
  }
}

module "snowflake_default_role" {
  for_each = local.default_roles

  source  = "getindata/database-role/snowflake"
  version = "2.0.1"

  database_name     = snowflake_stage.this.database
  context_templates = var.context_templates

  name = each.key
  name_scheme = merge(
    local.default_role_naming_scheme,
    lookup(each.value, "name_scheme", {})
  )
  comment = lookup(each.value, "comment", null)

  granted_to_roles          = lookup(each.value, "granted_to_roles", [])
  granted_to_database_roles = lookup(each.value, "granted_to_database_roles", [])
  granted_database_roles    = lookup(each.value, "granted_database_roles", [])

  schema_objects_grants = {
    "STAGE" = [
      {
        privileges        = lookup(each.value, "stage_grants", null)
        all_privileges    = lookup(each.value, "all_privileges", null)
        with_grant_option = lookup(each.value, "with_grant_option", false)
        on_future         = lookup(each.value, "on_future", false)
        on_all            = lookup(each.value, "on_all", false)
        object_name       = (lookup(each.value, "on_future", false) || lookup(each.value, "on_all", false)) ? null : snowflake_stage.this.name
        schema_name       = snowflake_stage.this.schema
      }
    ]
  }
}

module "snowflake_custom_role" {
  for_each = local.custom_roles

  source  = "getindata/database-role/snowflake"
  version = "2.0.1"

  database_name     = snowflake_stage.this.database
  context_templates = var.context_templates

  name = each.key
  name_scheme = merge(
    local.default_role_naming_scheme,
    lookup(each.value, "name_scheme", {})
  )
  comment = lookup(each.value, "comment", null)

  granted_to_roles          = lookup(each.value, "granted_to_roles", [])
  granted_to_database_roles = lookup(each.value, "granted_to_database_roles", [])
  granted_database_roles    = lookup(each.value, "granted_database_roles", [])

  schema_objects_grants = {
    "STAGE" = [
      {
        privileges        = lookup(each.value, "stage_grants", null)
        all_privileges    = lookup(each.value, "all_privileges", null)
        with_grant_option = lookup(each.value, "with_grant_option", false)
        on_future         = lookup(each.value, "on_future", false)
        on_all            = lookup(each.value, "on_all", false)
        object_name       = (lookup(each.value, "on_future", false) || lookup(each.value, "on_all", false)) ? null : snowflake_stage.this.name
        schema_name       = snowflake_stage.this.schema
      }
    ]
  }
}
