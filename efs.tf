# https://medium.com/swlh/terraform-aws-batch-and-aws-efs-8682c112d742 

# EFS for sharing stuff

resource "aws_efs_file_system" "efs_fs" {

  count          = var.efs_name != "" ? 1 : 0
  creation_token = format("%s-%s", "efs", random_string.rand.result)
  # performance_mode = null
  # encrypted        = false
}

// We assign only one subnet_id
resource "aws_efs_mount_target" "efs_mount_target" {
  count          = length(tolist(var.batch_subnets))
  file_system_id = aws_efs_file_system.efs_fs[0].id
  subnet_id      = tolist(var.batch_subnets)[count.index]
  security_groups = [
    aws_security_group.allow_all.id
  ]
  depends_on = [aws_efs_file_system.efs_fs]
}

resource "aws_launch_template" "efs_launch_template" {
  name                   = "efs_launch_template"
  update_default_version = true
  user_data              = data.template_cloudinit_config.userdata_config.rendered
  depends_on             = [aws_efs_file_system.efs_fs]
}

data "template_cloudinit_config" "userdata_config" {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/cloud-boothook"
    content      = file("${path.module}/cloud_boothook.cfg")
  }
  # Main cloud-config configuration file.
  part {
    content_type = "text/cloud-config"
    content      = data.template_file.efs_cloud_init_template_file.rendered
  }
}

data "template_file" "efs_cloud_init_template_file" {

  template = file("${path.module}/cloud_init.tpl")
  vars = {
    efs_id        = aws_efs_file_system.efs_fs[0].id
    efs_directory = var.efs_path
  }
}
