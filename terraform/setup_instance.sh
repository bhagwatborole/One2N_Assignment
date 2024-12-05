#!/bin/bash

sudo yum update -y

sudo yum install -y git python3-pip

cd /home/ec2-user
git clone https://github.com/bhagwatborole/One2N_Assignment

cd /home/ec2-user/One2N_Assignment

pip3 install -r requirements.txt

gunicorn -b 0.0.0.0:5000 list_bucket:app --daemon --access-logfile /home/ec2-user/access.log --error-logfile /home/ec2-user/error.log

echo "Your application is available at:"
echo "http://${public_ip}/list-bucket-content"
echo "http://${public_ip}/list-bucket-content/test1"
echo "http://${public_ip}/list-bucket-content/test2"

