// Batch configuration

resource "aws_batch_compute_environment" "compute" {

  for_each = { for k, v in var.compute_environments : k => v }

  compute_environment_name = format("%s-%s", each.key, random_string.rand.result)

  compute_resources {

    subnets = each.value.subnets

    instance_role = aws_iam_instance_profile.ComputeInstanceProfile.arn

    image_id = lookup(each.value, "image_id", null)

    max_vcpus     = each.value.max_vcpus
    min_vcpus     = each.value.min_vcpus
    desired_vcpus = each.value.desired_vcpus

    type = each.value.type

    instance_type = each.value.instance_type

    launch_template {
      launch_template_id = var.efs_name == "" ? null : aws_launch_template.efs_launch_template.id
      version            = aws_launch_template.efs_launch_template.latest_version
    }

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

  name     = lookup(each.value, "name", each.key)
  state    = "ENABLED"
  priority = each.value.priority
  compute_environments = [
    for env in aws_batch_compute_environment.compute :
    env.arn if contains(each.value.compute, replace(env.compute_environment_name, format("-%s", random_string.rand.result), ""))
  ]

  depends_on = [aws_batch_compute_environment.compute]

  tags = {
    name = format("queue-%s-%s", lookup(each.value, "name", each.key), random_string.rand.result)
  }
}
