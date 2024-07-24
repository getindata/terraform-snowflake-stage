output "name" {
  description = "Name of the stage"
  value       = one(snowflake_stage.this[*].name)
}

output "database_roles" {
  description = "This stage access roles"
  value       = local.roles
}
