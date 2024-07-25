resource "snowflake_database" "this" {
  name = "USERS_DB"
}

resource "snowflake_schema" "this" {
  name     = "TEST_SCHEMA"
  database = snowflake_database.this.name
}

module "internal_stage" {
  source = "../../"

  name     = "my_stage"
  schema   = snowflake_schema.this.name
  database = snowflake_database.this.name
}
