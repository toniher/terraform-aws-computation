# https://medium.com/swlh/terraform-aws-batch-and-aws-efs-8682c112d742 

# EFS for sharing stuff

resource "aws_efs_file_system" "efs" {

  for_each = { for k, v in var.mount_points : k => v }

  creation_token   = each.key
  performance_mode = lookup(each.value, "performance_mode", null)
  encrypted        = lookup(each.value, "encrypted", "false")

}

resource "aws_efs_mount_target" "efs_mount_target" {
  count          = length(var.batch_subnets)
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = element(tolist(var.batch_subnets), count.index)
  security_groups = [
    aws_security_group.allow_all.id
  ]
}

resource "aws_launch_template" "launch_template" {
  name                   = "launch_template"
  update_default_version = true
  user_data              = base64encode(data.template_file.efs_template_file.rendered)
}

data "template_file" "efs_template_file" {
  template = file("${path.module}/launch_template_user_data.tpl")
  count    = length(keys(var.mount_points))
  vars = {
    efs_id        = aws_efs_file_system.efs[count.index].id
    efs_directory = "/mnt/efs"
  }
}
