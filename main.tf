module "stage_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"
  context = module.this.context

  delimiter           = coalesce(module.this.context.delimiter, "_")
  regex_replace_chars = coalesce(module.this.context.regex_replace_chars, "/[^_a-zA-Z0-9]/")
  label_value_case    = coalesce(module.this.context.label_value_case, "upper")
}

resource "snowflake_stage" "this" {
  count = module.this.enabled ? 1 : 0

  name     = local.name_from_descriptor
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

# module "snowflake_default_database_role" {

module "snowflake_database_role" {
  # for_each = local.create_default_roles ? local.default_roles : {}
  for_each = local.roles

  source = "git::ssh://git@github.com/getindata/terraform-snowflake-database-role.git"
  # version = "1.0.0"
  context = module.this.context

  database_name = one(snowflake_stage.this[*].database)
  name          = each.key

  parent_database_role   = lookup(each.value, "parent_database_role", null)
  granted_database_roles = lookup(each.value, "granted_database_roles", [])

  attributes = [
    one(snowflake_stage.this[*].schema),
    one(snowflake_stage.this[*].name)
  ]

  schema_objects_grants = {
    "STAGE" = [
      {
        privileges        = lookup(each.value, "stage_grants", null)
        all_privileges    = lookup(each.value, "all_privileges", null)
        with_grant_option = lookup(each.value, "with_grant_option", false)
        on_future         = lookup(each.value, "on_future", false)
        on_all            = lookup(each.value, "on_all", false)
        object_name       = (lookup(each.value, "on_future", false) || lookup(each.value, "on_all", false)) ? null : one(snowflake_stage.this[*].name)
        schema_name       = one(snowflake_stage.this[*].schema)
      }
    ]
  }
}

# module "snowflake_custom_database_role" {
#   for_each = local.custom_roles

#   source = "git::ssh://git@github.com/getindata/terraform-snowflake-database-role.git"
#   # version = "1.0.0"
#   context = module.this.context

#   database_name = one(snowflake_stage.this[*].database)
#   name          = each.key

#   parent_database_role   = lookup(each.value, "parent_database_role", null)
#   granted_database_roles = lookup(each.value, "granted_database_roles", [])

#   attributes = [
#     one(snowflake_stage.this[*].schema),
#     one(snowflake_stage.this[*].name)
#   ]

#   schema_objects_grants = {
#     "STAGE" = [
#       {
#         privileges        = lookup(each.value, "stage_grants", null)
#         all_privileges    = lookup(each.value, "all_privileges", null)
#         with_grant_option = lookup(each.value, "with_grant_option", false)
#         on_future         = lookup(each.value, "on_future", false)
#         on_all            = lookup(each.value, "on_all", false)
#         object_name       = (lookup(each.value, "on_future", false) || lookup(each.value, "on_all", false)) ? null : one(snowflake_stage.this[*].name)
#         schema_name       = one(snowflake_stage.this[*].schema)
#       }
#     ]
#   }
# }

resource "snowflake_grant_ownership" "stage_ownership" {
  count = var.stage_ownership_grant != null ? 1 : 0

  database_role_name = module.snowflake_database_role[var.stage_ownership_grant].fully_qualified_name
  outbound_privileges = "REVOKE"
  on {
    object_type = "STAGE"
    object_name = local.schema_object_stage_name
  }
}
