terraform {
    source = "git::https://github.com/swapnilbharshankar/infrastructureascode-terraform//azure/network?ref=azure-0.0.1"
}

include "root" {
    path = find_in_parent_folders("root.hcl")
    expose = true
}

locals {
    #common_vars = yamldecode(file("${get_parent_terragrunt_dir()}/${include.root.locals.cloud}/conf.d/${include.root.locals.env}/${include.root.locals.env}-resources.yaml"))
    common_vars = yamldecode(file("${get_parent_terragrunt_dir()}/azure/conf.d/prod-accounts/prod-a/prod-a-resources.yaml"))
}

inputs = {
    name = local.common_vars.common.name
    parent_id = "${get_env("TF_VAR_PARENT_ID", "")}"
}