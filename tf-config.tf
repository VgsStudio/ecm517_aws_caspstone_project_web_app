terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.14.0"
    }
  }
}

variable "aws_profile" {
  description = "The AWS profile to use"
  type        = string

}

provider "aws" {
  region  = "us-east-1"
  profile = var.aws_profile

  default_tags {
    tags = {
      ORIGIN = "TERRAFORM"
    }
  }
}
