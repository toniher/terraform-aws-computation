packages:
- amazon-efs-utils
runcmd:
- mkdir -p ${efs_directory}
- echo "${efs_id}:/ ${efs_directory} efs _netdev,tls,iam 0 0" >> /etc/fstab
- mount -a -t efs defaults
