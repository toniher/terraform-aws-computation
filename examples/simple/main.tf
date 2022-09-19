provider "aws" {
  region                   = local.region
  profile                  = local.profile
  shared_credentials_files = local.credentials

}

locals {
  region      = "eu-central-1"
  profile     = "default"
  credentials = "/path/to/credentials"
}

module "aws-computation" {
  source = "../.."

  ec2_count         = 2
  ec2_ami           = "amixxxx"
  ec2_password      = "my_password"
  ec2_instance_type = "t2.micro"
  ec2_volume_size   = 10
  bucket_destroy    = true
  bucket_acl        = "private"
  bucket_prefix     = "my-new-bucket"
  repo_url          = ""
}