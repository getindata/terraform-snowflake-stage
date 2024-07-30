resource "snowflake_database" "this" {
  name = "USERS_DB"
}

resource "snowflake_schema" "this" {
  name     = "TEST_SCHEMA"
  database = snowflake_database.this.name
}

resource "snowflake_role" "role_1" {
  name = "ROLE_1"
}

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

module "internal_stage" {
  source  = "../../"
  context = module.this.context

  name     = "INGEST"
  schema   = snowflake_schema.this.name
  database = snowflake_database.this.name

  comment = "This is my ingest stage"

  create_default_roles = true

  roles = {
    readonly = { # Modifies readonly default database role
      granted_to_database_roles = [
        "${snowflake_database.this.name}.${snowflake_database_role.db_role_1.name}"
      ]
      granted_database_roles = [
        "${snowflake_database.this.name}.${snowflake_database_role.db_role_2.name}",
        "${snowflake_database.this.name}.${snowflake_database_role.db_role_3.name}"
      ]
      stage_grants = ["READ", "WRITE"]
    }
    admin = { # Modifies admin default database role
      granted_database_roles = [
        "${snowflake_database.this.name}.${snowflake_database_role.db_role_2.name}",
      ]
    }
    readwrite = {
      enabled = false # Disables readwrite default database role creation
    }
    role_1 = { # Database role created by user input
      granted_to_roles          = [snowflake_role.role_1.name]
      granted_to_database_roles = ["${snowflake_database.this.name}.${snowflake_database_role.db_role_3.name}"]
      all_privileges            = true
      with_grant_option         = true
      on_future                 = true
      on_all                    = true
    }
    role_2 = { # Database role created by user input
      granted_to_database_roles = ["${snowflake_database.this.name}.${snowflake_database_role.db_role_3.name}"]
      stage_grants              = ["READ", "WRITE"]
      with_grant_option         = false
      on_future                 = true
      on_all                    = false
    }
  }

  stage_ownership_grant = "role_1" # When destroying, please read README.md
}
