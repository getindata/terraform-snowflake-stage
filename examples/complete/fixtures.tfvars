context_templates = {
  snowflake-stage               = "{{.name}}"
  snowflake-project-stage       = "{{.project}}_{{.name}}"
  snowflake-stage-database-role = "{{.schema}}_{{.stage}}_{{.suffix}}_{{.name}}"
}
