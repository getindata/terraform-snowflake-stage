module "internal_stage" {
  source = "../../"

  name     = "my_stage"
  schema   = "my_schema"
  database = "my_db"
}
