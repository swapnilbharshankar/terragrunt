include {
    path            = find_in_parent_folders()
}

terraform {
    source          = "tfr://terraform-aws-modules/vpc/aws//?version=5.8.1"
}

inputs = {
    environment     = "prod"
    cidr_block      = "10.0.0.0/16"
}