# Snowflake Stage Terraform Module
![Snowflake](https://img.shields.io/badge/-SNOWFLAKE-249edc?style=for-the-badge&logo=snowflake&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

![License](https://badgen.net/github/license/getindata/terraform-snowflake-stage/)
![Release](https://badgen.net/github/release/getindata/terraform-snowflake-stage/)

<p align="center">
  <img height="150" src="https://getindata.com/img/logo.svg">
  <h3 align="center">We help companies turn their data into assets</h3>
</p>

---

Terraform module for Snowflake stage management.

- Creates Snowflake stage
- Can create custom Snowflake database-roles with role-to-role assignments
- Can create a set of default roles to simplify access management:
  - `READONLY` - granted `USAGE` or `READ` privilages
  - `READWRITE` - granted `WRITE` privileges
  - `ADMIN` - granted `ALL PRIVILEGES`

## USAGE

```terraform
module "snowflake_stage" {
  source = "getindata/stage/snowflake"
  # version  = "x.x.x"

  name     = "my_stage"
  schema   = "my_schema"
  database = "my_db"
  
  url         = "s3://com.example.bucket/prefix"
  credentials = "AWS_KEY_ID='${var.example_aws_key_id}' AWS_SECRET_KEY='${var.example_aws_secret_key}'"
  
  create_default_database_roles = true
}
```

## EXAMPLES

- [Simple](examples/simple) - Basic usage of the module
- [Complete](examples/complete) - Advanced usage of the module

## Breaking changes in v2.x of the module

Due to breaking changes in Snowflake provider and additional code optimizations, **breaking changes** were introduced in `v2.0.0` version of this module.

List of code and variable (API) changes:

- Switched to `snowflake_grant_ownership` resource instead of provider-removed `snowflake_role_ownership_grant`
- Switched to `snowflake_database_role` module to leverage new `database_roles` mechanism
- `default_roles` and `custom_roles` are now combined and managed by single module
- `roles` variable map received following additions:
  - `all_privileges` - optional, bool
  - `on_all` - optional, bool, defaults to false
  - `on_future` - optional, bool, defaults to false
  - `with_grant_option` - optional, bool
  - `granted_to_database_roles` - optional, string
  - `granted_database_roles` - optional, list of strings

- and got following items removed:
  - `enabled`
  - `comment`
  - `role_ownership_grant`
  - `granted_roles`
  - `granted_to_users`


When upgrading from `v1.x`, expect most of the resources to be recreated - if recreation is impossible, then it is possible to import some existing resources.

For more information, refer to [variables.tf](variables.tf), list of inputs below and Snowflake provider documentation

## Breaking changes in v3.x of the module

Due to replacement of nulllabel (`context.tf`) with context provider, some **breaking changes** were introduced in `v3.0.0` version of this module.

List od code and variable (API) changes:

- Removed `context.tf` file (a single-file module with additonal variables), which implied a removal of all its variables (except `name`):
  - `descriptor_formats`
  - `label_value_case`
  - `label_key_case`
  - `id_length_limit`
  - `regex_replace_chars`
  - `label_order`
  - `additional_tag_map`
  - `tags`
  - `labels_as_tags`
  - `attributes`
  - `delimiter`
  - `stage`
  - `environment`
  - `tenant`
  - `namespace`
  - `enabled`
  - `context`
- Remove support `enabled` flag - that might cause some backward compatibility issues with terraform state (please take into account that proper `move` clauses were added to minimize the impact), but proceed with caution
- Additional `context` provider configuration
- New variables were added, to allow naming configuration via `context` provider:
  - `context_templates`
  - `name_schema`

## Breaking changes in v4.x of the module

Due to rename of Snowflake terraform provider source, all `versions.tf` files were updated accordingly.

Please keep in mind to mirror this change in your own repos also.

[Snowflake documentation](https://github.com/snowflakedb/terraform-provider-snowflake/blob/main/SNOWFLAKEDB_MIGRATION.md)

## Preview Feature Requirements (Provider version 1.x+)

Starting with Snowflake provider version `1.x`, the `snowflake_stage` resource is considered a preview feature and must be explicitly enabled in the provider configuration.

**Required Provider Configuration:**

```terraform
provider "snowflake" {
  preview_features_enabled = ["snowflake_stage_resource"]
}
```

Without this configuration, you will encounter the following error:

```shell
Error: snowflake_stage_resource is currently a preview feature, and must be enabled by adding snowflake_stage_resource to preview_features_enabled in Terraform configuration.
```

For more information about preview features, refer to the [Snowflake provider documentation](https://registry.terraform.io/providers/snowflakedb/snowflake/latest/docs/resources/stage#preview-features) and [Snowflake stage resource documentation](https://registry.terraform.io/providers/snowflakedb/snowflake/latest/docs/resources/stage).

<!-- BEGIN_TF_DOCS -->




## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_external_id"></a> [aws\_external\_id](#input\_aws\_external\_id) | ID of the customer AWS account | `string` | `null` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Specifies a comment for the stage | `string` | `null` | no |
| <a name="input_context_templates"></a> [context\_templates](#input\_context\_templates) | Map of context templates used for naming conventions - this variable supersedes `naming_scheme.properties` and `naming_scheme.delimiter` configuration | `map(string)` | `{}` | no |
| <a name="input_copy_options"></a> [copy\_options](#input\_copy\_options) | Specifies the copy options for the stage | `string` | `null` | no |
| <a name="input_create_default_roles"></a> [create\_default\_roles](#input\_create\_default\_roles) | Whether the default database roles should be created | `bool` | `false` | no |
| <a name="input_credentials"></a> [credentials](#input\_credentials) | Specifies the credentials for the stage | `string` | `null` | no |
| <a name="input_database"></a> [database](#input\_database) | The database in which to create the stage | `string` | n/a | yes |
| <a name="input_directory"></a> [directory](#input\_directory) | Specifies the directory settings for the stage | `string` | `null` | no |
| <a name="input_encryption"></a> [encryption](#input\_encryption) | Specifies the encryption settings for the stage | `string` | `null` | no |
| <a name="input_file_format"></a> [file\_format](#input\_file\_format) | Specifies the file format for the stage | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource | `string` | n/a | yes |
| <a name="input_name_scheme"></a> [name\_scheme](#input\_name\_scheme) | Naming scheme configuration for the resource. This configuration is used to generate names using context provider:<br/>    - `properties` - list of properties to use when creating the name - is superseded by `var.context_templates`<br/>    - `delimiter` - delimited used to create the name from `properties` - is superseded by `var.context_templates`<br/>    - `context_template_name` - name of the context template used to create the name<br/>    - `replace_chars_regex` - regex to use for replacing characters in property-values created by the provider - any characters that match the regex will be removed from the name<br/>    - `extra_values` - map of extra label-value pairs, used to create a name<br/>    - `uppercase` - convert name to uppercase | <pre>object({<br/>    properties            = optional(list(string), ["name"])<br/>    delimiter             = optional(string, "_")<br/>    context_template_name = optional(string, "snowflake-stage")<br/>    replace_chars_regex   = optional(string, "[^a-zA-Z0-9_]")<br/>    extra_values          = optional(map(string))<br/>    uppercase             = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | Database roles created in the stage scope | <pre>map(object({<br/>    name_scheme = optional(object({<br/>      properties            = optional(list(string))<br/>      delimiter             = optional(string)<br/>      context_template_name = optional(string)<br/>      replace_chars_regex   = optional(string)<br/>      extra_labels          = optional(map(string))<br/>      uppercase             = optional(bool)<br/>    }))<br/>    comment                   = optional(string)<br/>    with_grant_option         = optional(bool)<br/>    granted_to_roles          = optional(list(string))<br/>    granted_to_database_roles = optional(list(string))<br/>    granted_database_roles    = optional(list(string))<br/>    stage_grants              = optional(list(string))<br/>    all_privileges            = optional(bool)<br/>  }))</pre> | `{}` | no |
| <a name="input_schema"></a> [schema](#input\_schema) | The schema in which to create the stage | `string` | n/a | yes |
| <a name="input_snowflake_iam_user"></a> [snowflake\_iam\_user](#input\_snowflake\_iam\_user) | Specifies the Snowflake IAM user | `string` | `null` | no |
| <a name="input_stage_ownership_grant"></a> [stage\_ownership\_grant](#input\_stage\_ownership\_grant) | To which account role the stage ownership should be granted | `string` | `null` | no |
| <a name="input_storage_integration"></a> [storage\_integration](#input\_storage\_integration) | Specifies the name of the storage integration used to delegate authentication responsibility for external cloud storage to a Snowflake identity and access management (IAM) entity | `string` | `null` | no |
| <a name="input_url"></a> [url](#input\_url) | Specifies the URL for the stage | `string` | `null` | no |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_roles_deep_merge"></a> [roles\_deep\_merge](#module\_roles\_deep\_merge) | Invicton-Labs/deepmerge/null | 0.1.5 |
| <a name="module_snowflake_custom_role"></a> [snowflake\_custom\_role](#module\_snowflake\_custom\_role) | getindata/database-role/snowflake | 3.0.0 |
| <a name="module_snowflake_default_role"></a> [snowflake\_default\_role](#module\_snowflake\_default\_role) | getindata/database-role/snowflake | 3.0.0 |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_roles"></a> [database\_roles](#output\_database\_roles) | This stage access roles |
| <a name="output_fully_qualified_name"></a> [fully\_qualified\_name](#output\_fully\_qualified\_name) | Fully Qualified Name of the stage |
| <a name="output_name"></a> [name](#output\_name) | Name of the stage |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_context"></a> [context](#provider\_context) | >=0.4.0 |
| <a name="provider_snowflake"></a> [snowflake](#provider\_snowflake) | >= 0.95 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_context"></a> [context](#requirement\_context) | >=0.4.0 |
| <a name="requirement_snowflake"></a> [snowflake](#requirement\_snowflake) | >= 0.95 |

## Resources

| Name | Type |
|------|------|
| [snowflake_grant_ownership.stage_ownership](https://registry.terraform.io/providers/snowflakedb/snowflake/latest/docs/resources/grant_ownership) | resource |
| [snowflake_stage.this](https://registry.terraform.io/providers/snowflakedb/snowflake/latest/docs/resources/stage) | resource |
| [context_label.this](https://registry.terraform.io/providers/cloudposse/context/latest/docs/data-sources/label) | data source |
<!-- END_TF_DOCS -->

## CONTRIBUTING

Contributions are very welcomed!

Start by reviewing [contribution guide](CONTRIBUTING.md) and our [code of conduct](CODE_OF_CONDUCT.md). After that, start coding and ship your changes by creating a new PR.

## LICENSE

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.

## AUTHORS

<!--- Replace repository name -->
<a href="https://github.com/getindata/REPO_NAME/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=getindata/terraform-snowflake-stage" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
