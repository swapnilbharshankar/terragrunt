locals {
    path_components = split("/", path_relative_to_include())
    account_name    = local.path_components[1]
    aws_region      = local.path_components[2]
    env             = local.path_components[3]
    module          = local.path_components[4]
    env_vars        = yamldecode(
                        file(
                            "${get_parent_terragrunt_dir()}/aws/conf.d/${local.account_name}/${local.env}/${local.env}-resources.yaml"
                        )
                    )
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