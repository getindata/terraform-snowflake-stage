resource "snowflake_database_role" "db_role_1" {
  database = snowflake_database.this.name
  name     = "DB_ROLE_1"
}

resource "snowflake_database_role" "db_role_2" {
  database = snowflake_database.this.name
  name     = "DB_ROLE_2"
}

resource "snowflake_database_role" "db_role_3" {
  database = snowflake_database.this.name
  name     = "DB_ROLE_3"
}

resource "snowflake_database" "this" {
  name = "USERS_DB"
}

resource "snowflake_schema" "this" {
  name     = "TEST_SCHEMA"
  database = snowflake_database.this.name
}

module "internal_stage" {
  source  = "../../"
  context = module.this.context

  name     = "INGEST"
  schema   = snowflake_schema.this.name
  database = snowflake_database.this.name

  comment = "This is my ingest stage"

  create_default_databse_roles = true

  roles = {
    readonly = { # Modifies readonly default role
      parent_database_role = snowflake_database_role.db_role_1.name
      granted_database_roles = [
        snowflake_database_role.db_role_2.name,
        snowflake_database_role.db_role_3.name
      ]
      stage_grants = ["READ", "WRITE"]
    }
    admin = { # Modifies admin default role
      granted_database_roles = [
        snowflake_database_role.db_role_2.name
      ]
    }
    user_1 = { # User created database role
      parent_database_role = snowflake_database_role.db_role_3.name
      all_privileges       = true
      with_grant_option    = true
      on_future            = true
      on_all               = true
    }
    user_2 = { # User created database role
      parent_database_role = snowflake_database_role.db_role_3.name
      stage_grants         = ["READ", "WRITE"]
      with_grant_option    = false
      on_future            = true
      on_all               = false
    }
  }

  stage_ownership_grant = "user_1"
}
