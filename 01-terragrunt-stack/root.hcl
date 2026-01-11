locals {
    account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
    env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}


remote_state {
    backend = "s3"
    config = {
        bucket         = "swapnil-2026-state-${local.account_vars.locals.account_name}"
        key            = "${local.account_vars.locals.account_name}/${local.region_vars.locals.aws_region}/${local.env_vars.locals.env}.tfstate"
        region         = "us-east-1"
    }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}


generate "provider" {
    path       = "providers.tf"
    if_exists  = "overwrite_terragrunt"
    contents = <<EOF
provider "aws" {
    region = "${local.region_vars.locals.aws_region}"
}
EOF
}