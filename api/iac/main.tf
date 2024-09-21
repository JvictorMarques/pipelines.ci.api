terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.68.0"
    }
  }
}

provider "aws" {
  profile = "AdministratorAccess-864981720117"
  region  = "us-east-1"
}