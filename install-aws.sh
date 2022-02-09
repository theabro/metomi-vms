#### Install ec2-instance-connect for AWS EC2 instances, only needed if using Ubuntu 18.04
if [[ $dist == ubuntu ]]; then
  if [[ $release == 1804 ]]; then
    apt-get install -q -y ec2-instance-connect || error
  fi
fi
