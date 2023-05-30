#!/bin/bash

# Let's update first - Skip broken because problem with Apptainer (sic)
sudo yum update -y --skip-broken

sudo mkdir -p /mnt/${bucket_prefix}-${rand}-${count}

sudo s3fs -o iam_role="Multiaccess-${rand}" -o url="https://s3-${region}.amazonaws.com/" -o endpoint=${region} -o dbglevel=info -o umask=0022 -o uid=1000 -o gid=1000 -o curldbg -o allow_other -o default_acl=${bucket_acl} -o use_cache=/tmp ${bucket_prefix}-${rand}-${count} /mnt/${bucket_prefix}-${rand}-${count}

sudo sed -i '/^PasswordAuthentication/c\PasswordAuthentication yes' /etc/ssh/sshd_config

sudo echo "ec2-user:${ec2_password}"|chpasswd

sudo systemctl restart sshd

# EFS
if [ ! -z "${efs_directory}" ]
then
  sudo yum install -y amazon-efs-utils
  sudo mkdir -p ${efs_directory}
  echo "${efs_id}:/ ${efs_directory} efs _netdev,tls,iam 0 0" | sudo tee -a /etc/fstab
  sudo mount -a -t efs defaults
fi

# Git of the course

# Course should be adapted here
if [ ! -z "${repo_url}" ]
then
	mkdir -p /home/ec2-user/git
	cd /home/ec2-user/git; git clone ${repo_url}
	sudo chown -R ec2-user:ec2-user /home/ec2-user/git	
fi

# Let's record .bash_history for activity tracking

cat <<EOF >> /home/ec2-user/.bashrc
HISTFILESIZE=400000000
HISTSIZE=10000
PROMPT_COMMAND="history -a"
shopt -s histappend
EOF

# We clean above history
rm /home/ec2-user/.bash_history; touch /home/ec2-user/.bash_history; chown ec2-user:ec2-user /home/ec2-user/.bash_history;
