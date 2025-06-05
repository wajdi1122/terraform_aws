terraform {
  backend "s3" {
    bucket = "iovision-terraform-state"
    key    = "env/test/terraform.tfstate"
    region = "eu-north-1"
  }
}