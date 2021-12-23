provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA****************"
  secret_key = "1mfo**WIC/***************"
}

terraform {
  backend "s3" {
    bucket         = "terraformbuckt11"
    key            = "stage/global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

#create vpc
resource "aws_vpc" "my-vpc" {

  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-testvpc"
  }
}
resource "aws_subnet" "my-subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "my-test-subnet"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraformbuckt11"
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
