output "name" {
  description = "Name of the stage"
  value       = snowflake_stage.this.name
}

output "fully_qualified_name" {
  description = "Fully Qualified Name of the stage"
  value       = snowflake_stage.this.fully_qualified_name
}

output "database_roles" {
  description = "This stage access roles"
  value       = local.roles
}
