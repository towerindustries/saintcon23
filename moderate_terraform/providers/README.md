# Saintcon 23 - Cloud Automation

## Provider Overview

Terraform Providers are the plugins that allow Terraform to interact with various cloud providers.  The providers are maintained by the community and are not part of the core Terraform code.  This means that they are updated more frequently than the core Terraform code.  This also means that they are not always backwards compatible.  This is why we are using a specific version of the providers in this workshop.

```
https://registry.terraform.io/browse/providers
```

## Provider Instructions
Create ```providers.tf``` in your ```working_directory```.

Copy the following code into providers.tf

```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
  required_version = ">= 1.5.7"
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
```
Modify AWS version to 5.21.0 and optionally upgrade the terraform version to 1.6.1. This is dependent on the version you have installed.
```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.21.0"
    }
  }
  required_version = ">= 1.6.1"
}
```
## Delete the Provider Section
```/main.tf```
# Next Step: Data Sources
```/saintcon32/moderate_terraform/data/README.md```

# Appendix A: The Completed Code -- Spoiler Alert
```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
  required_version = ">= 1.5.7"
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
```
