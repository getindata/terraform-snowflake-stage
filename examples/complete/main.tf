module "snowflake_admin_role" {
  source  = "getindata/role/snowflake"
  version = "1.2.1"
  context = module.this.context
  name    = "admin"
}

module "snowflake_dev_role" {
  source  = "getindata/role/snowflake"
  version = "1.2.1"
  context = module.this.context
  name    = "dev"
}

resource "snowflake_database" "this" {
  name = "MY_DATABASE"
}

resource "snowflake_schema" "this" {
  name     = "MY_SCHEMA"
  database = snowflake_database.this.name
}

module "internal_stage" {
  source  = "../../"
  context = module.this.context

  name     = "my_stage"
  schema   = snowflake_schema.this.name
  database = snowflake_database.this.name

  comment = "This is my stage"

  create_default_roles = true
  roles = {
    readonly = {
      granted_to_roles = [module.snowflake_dev_role.name]
    }
    admin = {
      granted_to_roles = [module.snowflake_admin_role.name]
    }
  }
}
