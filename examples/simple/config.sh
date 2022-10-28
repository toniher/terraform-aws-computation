export TF_VAR_key_name=my-key
export TF_VAR_profile=default
export TF_VAR_credentials='["/home/user/.aws/credentials"]'
export TF_VAR_region=eu-central-1

export TF_VAR_ec2_count=2
export TF_VAR_ec2_ami=ami-xxx
export TF_VAR_ec2_password=my-dummy-passwd
export TF_VAR_ec2_instance_type=t2.micro
export TF_VAR_ec2_volume_size=10
export TF_VAR_ec2_volume_type=gp3
export TF_VAR_bucket_destroy=true
export TF_VAR_bucket_acl=private
export TF_VAR_bucket_prefix=my-dummy-bucket
export TF_VAR_repo_url=https://github.com/biocorecrg/MOP2

export TF_VAR_batch_subnets='["subnet-xxx", "subnet-yyy", "subnet-zzz"]'

export TF_VAR_batch_ami_spot=ami-xxx
export TF_VAR_batch_compute_environment_type_spot=SPOT
export TF_VAR_batch_bid_percentage_spot=99
export TF_VAR_batch_max_vcpus_spot=16
export TF_VAR_batch_min_vcpus_spot=0
export TF_VAR_batch_desired_vcpus_spot=0
export TF_VAR_batch_instance_type_spot='["optimal"]'

export TF_VAR_batch_ami_spot_gpu=ami-xxx
export TF_VAR_batch_compute_environment_type_spot_gpu=SPOT
export TF_VAR_batch_bid_percentage_spot_gpu=99
export TF_VAR_batch_max_vcpus_spot_gpu=16
export TF_VAR_batch_min_vcpus_spot_gpu=0
export TF_VAR_batch_desired_vcpus_spot_gpu=0
export TF_VAR_batch_instance_type_spot_gpu='["optimal"]'


export AWS_ACCOUNT_ID=$(aws sts get-caller-identity|jq .Account|tr -d \")
