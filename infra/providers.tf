terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      used_for     = "backup"
      application  = "restic"
      created_with = "terraform"
    }
  }
}

provider "aws" {
  alias  = "sydney"
  region = "ap-southeast-2"

  default_tags {
    tags = {
      used_for     = "backup"
      application  = "restic"
      created_with = "terraform"
    }
  }
}