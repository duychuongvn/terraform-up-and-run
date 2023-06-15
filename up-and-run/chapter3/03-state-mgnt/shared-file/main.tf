terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

#  backend "s3" {
#   bucket =  "smd-dev-terraform-state"
#    key     = "global/s3/terreform.tfstate"
#    region  = "ap-southeast-1"
#    dynamodb_table  = "smd-dev-terraform-state"
##    encrypt = true
 # }
}

resource "aws_s3_bucket" "terraform_state" {
    bucket = "smd-dev-terraform-state"
  
}

resource "aws_s3_bucket_versioning" "enabled" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
        status = "Enabled"
    }
}
resource "aws_s3_bucket_public_access_block" "public_access" {
    bucket = aws_s3_bucket.terraform_state.id
    block_public_acls   = true
    block_public_policy = true
    ignore_public_acls  = true
    restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = "smd-dev-terraform-state"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
}

output "s3_bucket_arn" {
    value = aws_s3_bucket.terraform_state.arn
    description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
    value = aws_dynamodb_table.terraform_locks.name
    description = "The name of the DynamoDB table"
}