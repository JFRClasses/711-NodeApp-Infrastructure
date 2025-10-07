terraform {
  backend "s3" {
    bucket = "711-tfstate-juan"
    key = "./terraform.tfstate"
    region = "us-east-2"
    encrypt = true
    dynamodb_table = "711-tfstate-dynamodb"
  }
}


provider "aws" {
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
  region     = var.AWS_REGION
}

# terraform -chdir=./envs/dev init --upgrade