variable "profile" {
    type    = string
    default = "default"
}

variable "credentials" {
    type = string
}

variable "region" {
    type = string
}

variable "key_name" {
    type = string
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
