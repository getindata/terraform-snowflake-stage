# Simple Example

```terraform
module "internal_stage" {
  source = "../../"

  name     = "my_stage"
  schema   = "my_schema"
  database = "my_db"
}
```

## Usage
Populate `.env` file with Snowflake credentials and make sure it's sourced to your shell.

```
terraform init
terraform plan -out tfplan
terraform apply tfplan
```
