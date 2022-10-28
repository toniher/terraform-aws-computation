// Batch configuration

resource "aws_batch_compute_environment" "compute" {

  for_each = { for k, v in var.compute_environments : k => v }

  compute_environment_name = format("%s-%s", lookup(each.value, "name", null), random_string.rand.result)

  dynamic "compute_resources" {
    content {

      subnets = var.batch_subnets

      instance_role = aws_iam_instance_profile.ComputeInstanceProfile.arn

      image_id = compute_resources.value.image_id

      max_vcpus     = compute_resources.value.max_vcpus
      min_vcpus     = compute_resources.value.min_vcpus
      desired_vcpus = compute_resources.value.desired_vcpus

      instance_type = compute_resources.value.instance_type

      spot_iam_fleet_role = (compute_resources.value.type == "SPOT" ? aws_iam_role.ClusterFleetRole.arn : null)

      bid_percentage = (compute_resources.value.type == "SPOT" ? compute_resources.value.bid_percentage : null)

      security_group_ids = [aws_security_group.allow_all.id]

    }

  }

  service_role = aws_iam_role.ClusterRole.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_policy_attachment.AWSBatchServiceRole-policy-attachment]

  tags = {
    name = format("compute-%s-%s", lookup(each.value, "name", null), random_string.rand.result)
  }
}


resource "aws_batch_job_queue" "queue" {

  for_each = { for k, v in var.job_queues : k => v }

  name                 = each.value.name
  state                = "ENABLED"
  priority             = each.value.priority
  compute_environments = [for env in aws_batch_compute_environment.compute : env.arn]

  depends_on = [aws_batch_compute_environment.compute]

  tags = {
    name = "queue-${each.value.name}"
  }
}
