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

module "snowflake_default_role" {
  for_each = local.default_roles

  source  = "getindata/role/snowflake"
  version = "1.2.1"
  context = module.this.context
  enabled = local.create_default_roles && lookup(each.value, "enabled", true)

  name = each.key
  attributes = [
    one(snowflake_stage.this[*].database),
    one(snowflake_stage.this[*].schema),
    one(snowflake_stage.this[*].name)
  ]

  role_ownership_grant = lookup(each.value, "role_ownership_grant", "SYSADMIN")
  granted_to_users     = lookup(each.value, "granted_to_users", [])
  granted_to_roles     = lookup(each.value, "granted_to_roles", [])
  granted_roles        = lookup(each.value, "granted_roles", [])
}

module "snowflake_custom_role" {
  for_each = local.custom_roles

  source  = "getindata/role/snowflake"
  version = "1.2.1"
  context = module.this.context
  enabled = module.this.enabled && lookup(each.value, "enabled", true)

  name = each.key
  attributes = [
    one(snowflake_stage.this[*].database),
    one(snowflake_stage.this[*].schema),
    one(snowflake_stage.this[*].name)
  ]

  role_ownership_grant = lookup(each.value, "role_ownership_grant", "SYSADMIN")
  granted_to_users     = lookup(each.value, "granted_to_users", [])
  granted_to_roles     = lookup(each.value, "granted_to_roles", [])
  granted_roles        = lookup(each.value, "granted_roles", [])
}

resource "snowflake_stage_grant" "this" {
  for_each = module.this.enabled ? transpose({ for role_name, role in local.roles : local.roles[role_name].name =>
    lookup(local.roles_definition[role_name], "stage_grants", [])
    if lookup(local.roles_definition[role_name], "enabled", true)
  }) : {}

  database_name = one(snowflake_stage.this[*].database)
  schema_name   = one(snowflake_stage.this[*].schema)
  stage_name    = one(snowflake_stage.this[*].name)
  privilege     = each.key
  roles         = each.value
}
