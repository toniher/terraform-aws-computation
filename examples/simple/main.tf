variable "key_name" {
  type = string
}

variable "profile" {
  type = string
}

variable "credentials" {
  type = list(string)
}

variable "region" {
  type = string
}

variable "ec2_count" {
  type = number
}

variable "ec2_ami" {
  type = string
}

variable "ec2_password" {
  type = string
}

variable "ec2_instance_type" {
  type = string
}

variable "ec2_volume_size" {
  type = number
}

variable "bucket_destroy" {
  type = bool
}

variable "bucket_acl" {
  type = string
}

variable "bucket_prefix" {
  type = string
}

variable "repo_url" {
  type = string
}


// Batch variables

variable "batch_subnets" {
  type = list(string)

}

variable "batch_ami" {
  type = string
}

variable "batch_bid_percentage" {
  type    = number
  default = 50
}

variable "batch_max_vcpus" {
  type = number
}

variable "batch_min_vcpus" {
  type = number
}

variable "batch_desired_vcpus" {
  type = number
}

variable "batch_instance_type" {
  type = list(string)
}

variable "batch_compute_environment_name" {
  type = string
}

variable "batch_compute_environment_type" {
  type = string
}

variable "batch_queue_name" {
  type = string
}


provider "aws" {
  region                   = var.region
  profile                  = var.profile
  shared_credentials_files = var.credentials

}

module "aws-computation" {
  // source = "git::https://github.com/toniher/terraform-aws-computation"
  source = "../.."

  key_name          = var.key_name
  ec2_count         = var.ec2_count
  ec2_ami           = var.ec2_ami
  ec2_password      = var.ec2_password
  ec2_instance_type = var.ec2_instance_type
  ec2_volume_size   = var.ec2_volume_size
  ec2_volume_type   = var.ec2_volume_type
  bucket_destroy    = var.bucket_destroy
  bucket_acl        = var.bucket_acl
  bucket_prefix     = var.bucket_prefix
  repo_url          = var.repo_url

  compute_environments = {

    default = {

      batch_subnets                  = var.batch_subnets
      batch_ami                      = var.batch_ami
      batch_compute_environment_type = var.batch_compute_environment_type
      batch_bid_percentage           = var.batch_bid_percentage
      batch_max_vcpus                = var.batch_max_vcpus
      batch_min_vcpus                = var.batch_min_vcpus
      batch_desired_vcpus            = var.batch_desired_vcpus
      batch_instance_type            = var.batch_instance_type
      batch_compute_environment_name = var.batch_compute_environment_name
      batch_queue_name               = var.batch_queue_name

    }

  }

}
