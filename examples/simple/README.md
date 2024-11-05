# Simple example

This is simple usage example of `snowflake-stage` terraform module.

## How to plan

```shell
terraform init
terraform plan
```

## How to apply

```shell
terraform init
terraform apply
```

## How to destroy

```shell
terraform destroy
```

<!-- BEGIN_TF_DOCS -->




## Inputs

No inputs.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_internal_stage"></a> [internal\_stage](#module\_internal\_stage) | ../../ | n/a |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_internal_stage"></a> [internal\_stage](#output\_internal\_stage) | Internal stage module outputs |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_snowflake"></a> [snowflake](#provider\_snowflake) | ~> 0.95 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | ~> 0.95 |

## Resources

| Name | Type |
|------|------|
| [snowflake_database.this](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/database) | resource |
| [snowflake_schema.this](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/schema) | resource |
<!-- END_TF_DOCS -->
