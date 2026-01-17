locals {
    # account_name = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    # aws_region = read_terragrunt_config(find_in_parent_folders("region.hcl"))
    # env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
    path_components = split("/", path_relative_to_include())
    account_name = local.path_components[1]
    aws_region = local.path_components[2]
    env = local.path_components[3]
    module = local.path_components[4]
    env_vars = yamldecode(file("${get_parent_terragrunt_dir()}/aws/conf.d/dev/dev-resources.yaml"))
}

remote_state {
    backend = "s3"
    config = {
        bucket         = "swapnil-2026-state-${local.account_name}"
        key            = "${local.account_name}/${local.aws_region}/${local.env}/${local.module}.tfstate"
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
    region = "${local.aws_region}"
}
EOF
}