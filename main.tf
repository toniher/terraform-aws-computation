// Random resource for naming
resource "random_string" "rand" {
    length  = 8
    special = false
    upper = false
}

resource "aws_instance" "ec2-entrypoint" {

    ami                  = var.ec2_ami
    count                = var.ec2_count
    instance_type        = var.ec2_instance_type
    iam_instance_profile = aws_iam_instance_profile.Multiprofile.name
    key_name             = var.key_name
    security_groups      = ["allow_ssh-${random_string.rand.result}", "allow_http-${random_string.rand.result}", "allow_shiny-${random_string.rand.result}"]
    user_data            = templatefile("ec2init.sh.tpl", { region = var.region, ec2_password = var.ec2_password, bucket_acl = var.bucket_acl, bucket_prefix = var.bucket_prefix, repo_url = var.repo_url, rand = random_string.rand.result, count = count.index + 1 })
    root_block_device {
        volume_size = var.ec2_volume_size
    }

    // We add additional sleep time for allowing creation and proper set up of image
    provisioner "local-exec" {
        command = "sleep 5"
    }

    // Let's wait all buckets to be created first. It could be even tried one by one
    depends_on = [aws_s3_bucket.class-bucket, aws_iam_instance_profile.Multiprofile]

    tags = {
    name = "classroom-${count.index + 1}"
    }

}

resource "aws_s3_bucket" "ec2-bucket" {
    count         = var.ec2_count
    bucket        = format("%s-%s", var.bucket_prefix, count.index + 1)
    acl           = var.bucket_acl
    force_destroy = var.bucket_destroy

    tags = {
        name = format("%s-%s", var.bucket_prefix, count.index + 1)
    }
}