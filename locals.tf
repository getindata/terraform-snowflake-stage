locals {
  # Get a name from the descriptor. If not available, use default naming convention.
  # Trim and replace function are used to avoid bare delimiters on both ends of the name and situation of adjacent delimiters.
  name_from_descriptor = module.stage_label.enabled ? trim(replace(
    lookup(module.stage_label.descriptors, var.descriptor_name, module.stage_label.id), "/${module.stage_label.delimiter}${module.stage_label.delimiter}+/", module.stage_label.delimiter
  ), module.stage_label.delimiter) : null

  schema_object_stage_name = "\"${one(snowflake_stage.this[*].database)}\".\"${one(snowflake_stage.this[*].schema)}\".\"${one(snowflake_stage.this[*].name)}\""

  is_internal = var.url == null

  default_roles_definition = var.create_default_database_roles ? {
    readonly = {
      enabled      = true
      stage_grants = local.is_internal ? ["READ"] : ["USAGE"]
    }
    readwrite = {
      enabled      = true
      stage_grants = local.is_internal ? ["READ", "WRITE"] : ["USAGE"]
    }
    admin = {
      enabled      = true
      stage_grants = local.is_internal ? ["READ", "WRITE"] : ["USAGE"]
    }
  } : {}

  provided_roles = { for role_name, role in var.roles : role_name => {
    for k, v in role : k => v
    if v != null
  } }

  roles = {
    for role_name, role in module.roles_deep_merge.merged : role_name => role
    if role_name != null && role.enabled
  }
}

module "roles_deep_merge" {
  source  = "Invicton-Labs/deepmerge/null"
  version = "0.1.5"

  maps = [local.default_roles_definition, local.provided_roles]
}
