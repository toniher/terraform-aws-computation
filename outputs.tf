output "public_dns" {
  value = aws_instance.ec2-entrypoint.*.public_dns
}

output "instance_id" {
  value = aws_instance.ec2-entrypoint.*.id
}

output "bucket_name" {
  value = aws_s3_bucket.ec2-bucket.*.bucket
}

/* output "queue" {
    value = aws_batch_job_queue.*.name
}
 */

output "rand_string" {
  value = random_string.rand.result
}