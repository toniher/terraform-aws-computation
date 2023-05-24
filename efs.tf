# https://medium.com/swlh/terraform-aws-batch-and-aws-efs-8682c112d742 

# EFS for sharing stuff

resource "aws_efs_file_system" "efs" {

  for_each = { for k, v in var.mount_points : k => v }

  creation_token   = each.key
  performance_mode = lookup(each.value, "performance_mode", null)
  encrypted        = lookup(each.value, "encrypted", "false")

}

// Get random subnet
resource "random_shuffle" "random_subnet" {
  input = tolist(var.batch_subnets)
}

// We assign only one subnet_id
resource "aws_efs_mount_target" "efs_mount_target" {
  count          = length(tolist(keys(var.mount_points)))
  file_system_id = aws_efs_file_system.efs[count.index].id
  subnet_id      = element(random_shuffle.random_subnet.result, 0)
  security_groups = [
    aws_security_group.allow_all.id
  ]
}

# resource "aws_launch_template" "launch_template" {
#   name                   = "launch_template"
#   update_default_version = true
#   user_data              = base64encode(data.template_file.efs_template_file[count.index].rendered)
# }
#
# data "template_file" "efs_template_file" {
#
#   for_each = { for k, v in var.mount_points : k => v }
#   template = file("${path.module}/launch_template_user_data.tpl")
#   vars = {
#     efs_id        = aws_efs_file_system.efs.*.id
#     efs_directory = lookup(each.value, "directory", "/mnt/efs")
#
#   }
# }
