# AWS Computation Terraform module

Terraform module which create some AWS resources for setting up a cloud computation infrastructure.

**IN PROGRESS**

## Usage

See [`examples`](https://github.com/toniher/terraform-aws-computation/tree/master/examples) directory for working examples to reference:


```hcl
provider "aws" {
  region                   = var.region
  profile                  = var.profile
  shared_credentials_files = var.credentials

}

module "aws-computation" {
  source = "git::https://github.com/toniher/terraform-aws-computation"

  key_name          = var.key_name
  ec2_count         = var.ec2_count
  ec2_ami           = var.ec2_ami
  ec2_password      = var.ec2_password
  ec2_instance_type = var.ec2_instance_type
  ec2_volume_size   = var.ec2_volume_size
  ec2_volume_type   = var.ec2_volume_type
  bucket_destroy    = var.bucket_destroy
  bucket_acl        = var.bucket_acl
  bucket_prefix     = var.bucket_prefix
  repo_url          = var.repo_url

  compute_environments = {
    spot = {
      subnets        = var.batch_subnets
      image_id       = var.batch_ami_spot
      type           = var.batch_compute_environment_type_spot
      bid_percentage = var.batch_bid_percentage_spot
      max_vcpus      = var.batch_max_vcpus_spot
      min_vcpus      = var.batch_min_vcpus_spot
      desired_vcpus  = var.batch_desired_vcpus_spot
      instance_type  = var.batch_instance_type_spot

    }
  }

  job_queues = {
    spot = {
      priority = 1
    }
  }

}
```

## TODO

* Change S3 permissions to only the ones defined
	* for_each for permission (ideally only to the matching EC2)
* Allow read-only S3 input buckets blocks
	* for_each for defining read-only policies. Buckets from var.bucket_input as a list
	* Attach policy to the same role
	* Put recipe in ec2init.tpl.sh for mounting them
	* Consider specific permissions if private ones: https://aws.amazon.com/premiumsupport/knowledge-center/s3-instance-access-bucket/

## References

* [AWS Batch Terraform module](https://registry.terraform.io/modules/terraform-aws-modules/batch/) - Parts of this module are based on this and it provides further customization for the Batch instance
