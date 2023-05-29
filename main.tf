// Random resource for naming
resource "random_string" "rand" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_instance" "ec2-entrypoint" {

  ami                  = var.ec2_ami
  count                = var.ec2_count
  instance_type        = var.ec2_instance_type
  iam_instance_profile = aws_iam_instance_profile.Multiprofile.name
  key_name             = var.key_name
  security_groups      = [aws_security_group.allow_ssh.name, aws_security_group.allow_http.name, aws_security_group.allow_shiny.name]
  user_data = templatefile("${path.module}/ec2init.sh.tpl", { region = var.region, ec2_password = var.ec2_password,
    bucket_acl = var.bucket_acl, bucket_prefix = var.bucket_prefix, repo_url = var.repo_url,
    rand       = random_string.rand.result, count = count.index + 1,
  efs_id = aws_efs_file_system.efs_fs[0].id, efs_directory = var.efs_path })
  root_block_device {
    volume_size = var.ec2_volume_size
    volume_type = var.ec2_volume_type
  }

  // We add additional sleep time for allowing creation and proper set up of image
  provisioner "local-exec" {
    command = "sleep 30"
  }

  // Let's wait all buckets to be created first. It could be even tried one by one
  depends_on = [aws_s3_bucket.ec2-bucket, aws_efs_file_system.efs_fs, aws_iam_instance_profile.Multiprofile]

  tags = {
    name = "ec2-entrypoint-${count.index + 1}"
  }

}

resource "aws_s3_bucket" "ec2-bucket" {
  count         = var.ec2_count
  bucket        = format("%s-%s-%s", var.bucket_prefix, random_string.rand.result, count.index + 1)
  force_destroy = var.bucket_destroy

  tags = {
    name = format("%s-%s-%s", var.bucket_prefix, random_string.rand.result, count.index + 1)
  }
}

resource "aws_s3_bucket_acl" "ec2-bucket-acl" {
  count      = var.ec2_count
  bucket     = aws_s3_bucket.ec2-bucket[count.index].id
  acl        = var.bucket_acl
  depends_on = [aws_s3_bucket_ownership_controls.ec2-bucket-acl-ownership]
}

resource "aws_s3_bucket_ownership_controls" "ec2-bucket-acl-ownership" {
  count  = var.ec2_count
  bucket = aws_s3_bucket.ec2-bucket[count.index].id
  rule {
    object_ownership = "ObjectWriter"
  }
}

