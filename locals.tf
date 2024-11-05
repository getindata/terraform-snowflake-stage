locals {
  context_template = lookup(var.context_templates, var.name_scheme.context_template_name, null)

  default_role_naming_scheme = {
    properties            = ["schema", "stage", "suffix", "name"]
    context_template_name = "snowflake-stage-database-role"
    extra_values = {
      stage  = var.name
      schema = var.schema
      suffix = "stg"
    }
  }

  is_internal = var.url == null

  default_roles_definition = {
    readonly = {
      stage_grants = local.is_internal ? ["READ"] : ["USAGE"]
    }
    readwrite = {
      stage_grants = local.is_internal ? ["READ", "WRITE"] : ["USAGE"]
    }
    admin = {
      stage_grants = local.is_internal ? ["ALL PRIVILEGES"] : ["USAGE"]
    }
  }

  roles_definition = module.roles_deep_merge.merged

  default_roles = {
    for role_name, role in local.roles_definition : role_name => role
    if contains(keys(local.default_roles_definition), role_name) && var.create_default_roles
  }

  custom_roles = {
    for role_name, role in local.roles_definition : role_name => role
    if !contains(keys(local.default_roles_definition), role_name)
  }

  provided_roles = {
    for role_name, role in var.roles : role_name => {
      for k, v in role : k => v
      if v != null
    }
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
