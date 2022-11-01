// Batch configuration

resource "aws_batch_compute_environment" "compute" {

  for_each = { for k, v in var.compute_environments : k => v }

  compute_environment_name = format("%s-%s", each.key, random_string.rand.result)

  compute_resources {

      subnets = each.value.subnets

      instance_role = aws_iam_instance_profile.ComputeInstanceProfile.arn

      image_id = each.value.image_id

      max_vcpus     = each.value.max_vcpus
      min_vcpus     = each.value.min_vcpus
      desired_vcpus = each.value.desired_vcpus

      type = each.value.type
      
      instance_type = each.value.instance_type

      spot_iam_fleet_role = (each.value.type == "SPOT" ? aws_iam_role.ClusterFleetRole.arn : null)

      bid_percentage = (each.value.type == "SPOT" ? each.value.bid_percentage : null)

      security_group_ids = [aws_security_group.allow_all.id]

  }

  service_role = aws_iam_role.ClusterRole.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_policy_attachment.AWSBatchServiceRole-policy-attachment]

  tags = {
    name = format("compute-%s-%s", each.key, random_string.rand.result)
  }
}


resource "aws_batch_job_queue" "queue" {

  for_each = { for k, v in var.job_queues : k => v }

  name                 = each.key
  state                = "ENABLED"
  priority             = each.value.priority
  compute_environments = [for env in aws_batch_compute_environment.compute : env.arn]

  depends_on = [aws_batch_compute_environment.compute]

  tags = {
    name = format("queue-%s-%s", each.key, random_string.rand.result)
  }
}
