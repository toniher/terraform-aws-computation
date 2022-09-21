// Batch configuration

resource "aws_batch_compute_environment" "compute" {

  compute_environment_name = format("%s-%s", var.batch_compute_environment_name, random_string.rand.result)

  compute_resources {
    instance_role = aws_iam_instance_profile.ComputeInstanceProfile.arn

    image_id = var.batch_ami

    max_vcpus     = var.batch_max_vcpus
    min_vcpus     = var.batch_min_vcpus
    desired_vcpus = var.batch_desired_vcpus

    instance_type = var.batch_instance_type

    subnets = var.batch_subnets

    type = var.batch_compute_environment_type

    spot_iam_fleet_role = (var.batch_compute_environment_type == "SPOT" ? aws_iam_role.ClusterFleetRole.arn : null)

    bid_percentage = (var.batch_compute_environment_type == "SPOT" ? var.batch_bid_percentage : null)

    security_group_ids = [aws_security_group.allow_all.id]

  }

  service_role = aws_iam_role.Multiaccess.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_policy_attachment.AWSBatchServiceRole-policy-attachment]

  tags = {
    name = format("compute-%s-%s", var.batch_compute_environment_name, random_string.rand.result)
  }
}


resource "aws_batch_job_queue" "queue" {

  name                 = var.batch_queue_name
  state                = "ENABLED"
  priority             = 1
  compute_environments = [aws_batch_compute_environment.compute.arn]

  depends_on = [aws_batch_compute_environment.compute]

  tags = {
    name = "queue-${var.batch_queue_name}"
  }
}
