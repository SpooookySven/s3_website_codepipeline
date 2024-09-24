provider "aws" {
  region  = var.region
}

terraform {
  backend "s3" {
    bucket         = "tf-state-s3-website-codepipeline"
    key            = "terraform.tfstate"
    encrypt        = true
    region         = "eu-west-1" 
  }
}