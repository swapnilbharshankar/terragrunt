locals {
    cloud               = split("/", get_terragrunt_dir())[2]
    environment         = split("/", get_terragrunt_dir())[1]
    region              = split("/", get_terragrunt_dir())[0]
}

remote_state {
    backend = "s3"
    generate = {
        path            = "terraform-backend.tf"
        if_exists       = "overwrite"
    }
    config = {
        bucket          = "swapnilbharshankar-my-terraform-state"
        key             = "${local.cloud}/${local.environment}/${local.region}/terraform.tfstate"
        region          = "${local.region}"
    }
}

generate "providers" {
    path                = "terraform-providers.tf"
    if_exists           = "overwrite"
    contents            = <<EOF
provider "aws" {
    region = ${local.region}
}
EOF
}