Steps for creating backend s3 to store state:
- Write code to create s3 bucket, dynamodb table. DO NOT write backend "s3" in terraform block


```
terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  #backend "s3" {
  #  bucket =  "smd-dev-terraform-state"
  #  key     = "global/s3/terreform.tfstate"
  #  region  = "ap-southeast-1"
  #  dynamodb_table  = "smd-dev-terraform-state"
  #  encrypt = true
  #}
}

```
- Run terraform init and terraform apply to create s3 bucket
- Add backend "s3" into terraform block and run terraform init

--> to destroy:
- REmove backend "s3" in terraform block
- run terraform init -migrate-state to copy state to local
- Remove lifecycle {prevent_destroy}
- Go to S3 Bucket and run Emtpy to remove all versions
- Run terraform destroy