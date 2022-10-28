output "public_dns" {
  value = module.aws-computation.public_dns
}

output "instance_id" {
  value = module.aws-computation.instance_id
}

output "bucket_name" {
  value = module.aws-computation.bucket_name
}

output "rand_string" {
  value = module.aws-computation.rand_string
}
