locals {
    path_components = split("/", path_relative_to_include())
    cloud           = local.path_components[0]
    account_name    = local.path_components[1]
    region          = local.path_components[2]
    env             = local.path_components[3]
    module          = local.path_components[4]
    env_vars        = yamldecode(
                        file(
                            "${get_parent_terragrunt_dir()}/${local.cloud}/conf.d/${local.account_name}/${local.env}/${local.env}-resources.yaml"
                        )
                    )
}

#remote_state {
#    backend = "s3"
#    config = {
#        bucket         = "swapnil-2026-state-${local.account_name}"
#        key            = "${local.account_name}/${local.region}/${local.env}/${local.module}.tfstate"
#        region         = "us-east-1"
#    }
#    generate = {
#        path      = "backend.tf"
#        if_exists = "overwrite_terragrunt"
#    }
#}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "local" {
    path = "${get_terragrunt_dir()}/terraform.tfstate"
  }
}
EOF
}

generate "provider" {
    path       = "providers.tf"
    if_exists  = "overwrite_terragrunt"
    contents = <<EOF
provider "aws" {
    region = "${local.region}"
}
EOF
}