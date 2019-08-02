terraform {
  backend "s3" {
    bucket = "tf-state-hello"
    key    = "tf-state"
    region = "eu-west-1"
  }
}

