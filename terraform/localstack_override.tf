# Lab-only override (Terraform merges *_override.tf into main.tf automatically).
# No AWS API credentials exist for this lab, so the AWS provider is pointed at LocalStack
# running on the same EC2 (127.0.0.1:4566). Dummy keys "test"/"test" are LocalStack's defaults.
# Delete this file and export real credentials to apply main.tf against real AWS.
provider "aws" {
  region                      = "ap-south-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  endpoints {
    ec2 = "http://127.0.0.1:4566"
    sts = "http://127.0.0.1:4566"
  }
}
