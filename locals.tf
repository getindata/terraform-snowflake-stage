locals {
  # Get a name from the descriptor. If not available, use default naming convention.
  # Trim and replace function are used to avoid bare delimiters on both ends of the name and situation of adjacent delimiters.
  name_from_descriptor = module.stage_label.enabled ? trim(replace(
    lookup(module.stage_label.descriptors, var.descriptor_name, module.stage_label.id), "/${module.stage_label.delimiter}${module.stage_label.delimiter}+/", module.stage_label.delimiter
  ), module.stage_label.delimiter) : null
  create_default_roles = module.this.enabled && var.create_default_roles

  is_internal = var.url == null

  default_roles_definition = {
    readonly = {
      stage_grants = local.is_internal ? ["READ"] : ["USAGE"]
    }
    readwrite = {
      stage_grants = local.is_internal ? ["READ", "WRITE"] : ["USAGE"]
    }
    admin = {
      stage_grants = local.is_internal ? ["READ", "WRITE", "OWNERSHIP"] : ["USAGE", "OWNERSHIP"]
    }
  }

  provided_roles = { for role_name, role in var.roles : role_name => {
    for k, v in role : k => v
    if v != null
  } }
  roles_definition = module.roles_deep_merge.merged

  default_roles = {
    for role_name, role in local.roles_definition : role_name => role
    if contains(keys(local.default_roles_definition), role_name)
  }
  custom_roles = {
    for role_name, role in local.roles_definition : role_name => role
    if !contains(keys(local.default_roles_definition), role_name)
  }

  roles = {
    for role_name, role in merge(
      module.snowflake_default_role,
      module.snowflake_custom_role
    ) : role_name => role
    if role.name != null
  }
}

module "roles_deep_merge" {
  source  = "Invicton-Labs/deepmerge/null"
  version = "0.1.5"

  maps = [local.default_roles_definition, local.provided_roles]
}
