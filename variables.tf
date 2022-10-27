// Variables

variable "key_name" {
  type    = string
  default = "my-key"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "ec2_count" {
  type    = number
  default = 2
}

variable "ec2_ami" {
  type = string
}

variable "ec2_password" {
  type = string
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ec2_volume_size" {
  type    = number
  default = 10
}

variable "ec2_volume_type" {
  type    = string
  default = "gp2"
}

variable "bucket_destroy" {
  type    = bool
  default = true
}

variable "bucket_acl" {
  type    = string
  default = "private"
}

variable "bucket_prefix" {
  type    = string
  default = "class-bucket"
}


variable "repo_url" {
  type    = string
  default = ""
}

// Batch variables

variable "batch_subnets" {
  type    = list(string)
  default = ["subnet-8a280df7", "subnet-c54d6588", "subnet-b85ab5d2"]
}
variable "batch_ami" {
  type = string
}

variable "batch_bid_percentage" {
  type    = number
  default = 50
}

variable "batch_max_vcpus" {
  type    = number
  default = 16
}

variable "batch_min_vcpus" {
  type    = number
  default = 0
}

variable "batch_desired_vcpus" {
  type    = number
  default = 0
}

variable "batch_instance_type" {
  type    = list(string)
  default = ["optimal"]
}

variable "batch_compute_environment_name" {
  type    = string
  default = "nf-compute-spot"
}

variable "batch_compute_environment_type" {
  type    = string
  default = "SPOT"
}

variable "batch_queue_name" {
  type    = string
  default = "spot"
}
