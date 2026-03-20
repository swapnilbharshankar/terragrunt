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
    path = "/Users/swapnilbharshankar/dev/tfstate/${local.cloud}/${local.module}/terraform.tfstate"
  }
}
EOF
}

# Generate the provider file conditionally
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
%{ if local.cloud == "aws" }
provider "aws" {
  region = ${local.region}
}
%{ endif }

%{ if local.cloud == "azure" }
provider "azurerm" {
  features {}
}
%{ endif }

%{ if local.cloud == "gcp" }
provider "google" {
    region = ${local.region}
}
%{ endif }
EOF
}

# Optional: Generate required_providers block to match
generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    %{ if local.cloud == "aws" }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    %{ endif }
    %{ if local.cloud == "azure" }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.64.0"
    }
    %{ endif }
    %{ if local.cloud == "gcp" }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.64.0"
    }
    %{ endif }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }    
  }
}
EOF
}
