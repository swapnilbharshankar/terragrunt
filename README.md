# Terragrunt Infrastructure Examples

This repository contains two Terragrunt stack examples for organizing Terraform infrastructure by account, region, and environment. The first is a small AWS VPC example with shared hierarchy-derived configuration. The second is a larger set of AWS and Azure examples with shared state/provider configuration, reusable Terraform modules, and Terragrunt dependencies.

These are configuration examples, not a turnkey production deployment. Review the backend, account, region, credentials, input values, and resource costs before running plans or applying changes.

## Repository layout

```text
.
├── 01-terragrunt-stack/
│   ├── root.hcl
│   └── demo/
│       ├── account.hcl
│       └── us-east-1/
│           ├── region.hcl
│           └── dev/
│               ├── env.hcl
│               └── vpc/
│                   ├── terragrunt.hcl
│                   └── vpc.yaml
└── 02-terragrunt-stack/
    ├── root.hcl
    ├── aws/
    │   ├── conf.d/                 # Environment input YAML
    │   ├── modules/                # Local EC2 and RDS Terraform modules
    │   ├── non-prod-account/       # Development Terragrunt units
    │   └── prod-account/           # Production-shaped Terragrunt units
    └── azure/
        ├── conf.d/                 # Environment input YAML
        └── prod-accounts/          # Network and VM Terragrunt units
```

## Stack overview

### `01-terragrunt-stack`

The root configuration derives the cloud, account, region, environment, and module from the unit's relative path. Account, region, and environment settings are split across `account.hcl`, `region.hcl`, and `env.hcl`; the VPC unit reads its inputs from `vpc.yaml` and uses the versioned AWS VPC module from the Terraform Registry.

This example currently generates a **local** Terraform backend at an absolute, machine-specific path in `root.hcl`. Update that path for your machine and ensure its parent directory exists before using the example. Do not use this state configuration for shared or production infrastructure.

The local state path includes the cloud and module, but not the account, region, or environment. As written, separate units with the same cloud and module can resolve to the same state file. Verify state-path uniqueness before running any command that initializes or changes state.

### `02-terragrunt-stack`

The shared root configuration expects account, region, and environment settings in parent HCL files, loads environment-specific YAML from `conf.d/`, configures a remote S3 state backend, and generates provider configuration. Those parent context HCL files are not present in the current tracked tree, so add or provide the required files before using this stack.

- **AWS:** Includes VPC, security-group, key-pair, EC2, RDS, and ALB units across development and production-shaped directory trees. EC2 and RDS Terraform modules are under `aws/modules/`; units refer to other units through Terragrunt dependencies.
- **Azure:** Includes network and virtual-machine units under `azure/prod-accounts/`. Their Terraform sources are external Git modules.
- **Inputs:** Environment values are supplied by YAML files under each cloud's `conf.d/` directory. Review these files locally before use and keep secrets out of source control.

The S3 bucket name is configured in `02-terragrunt-stack/root.hcl`; verify that the intended bucket exists and that your credentials have the necessary access. The configured state key includes account, region, and environment but not the Terragrunt unit, so multiple units in the same account/region/environment may collide. Correct the key scheme and confirm backend settings before using this stack.

## Prerequisites

- Terragrunt and Terraform versions compatible with the syntax and module sources used by the selected example.
- Cloud CLI credentials and permissions for the provider used by the selected unit.
- Network access to any external Terraform Registry or Git module sources.
- A configured backend. The first example uses a machine-specific local path; the second expects an S3 backend.

Use the version commands to verify your local tools:

```sh
terragrunt --version
terraform --version
```

## Plan a unit

Run Terragrunt from a leaf directory containing a `terragrunt.hcl`. For example, to inspect the first stack's VPC:

```sh
cd 01-terragrunt-stack/demo/us-east-1/dev/vpc
terragrunt plan
```

Or inspect the second stack's non-production VPC:

```sh
cd 02-terragrunt-stack/aws/non-prod-account/us-east-1/dev/vpc
terragrunt plan
```

Check the plan and all resolved inputs before applying. Other units can depend on outputs from neighboring units, so their dependencies and required state must be available. These examples may create billable cloud resources; do not run `apply` until you have reviewed the configuration, backend, credentials, and plan.

## Security and state

- Do not commit credentials, private keys, `.env` files, or secrets.
- The RDS unit receives a password through environment configuration. Supply secrets through an approved secret-management workflow rather than committing them in YAML. Terraform state may contain sensitive values; protect and restrict access to state.
- Review provider accounts, regions, resource names, network exposure, and deletion settings before planning or applying.
- Do not reuse the sample backend settings for production without designing and validating state access, protection, and recovery.
