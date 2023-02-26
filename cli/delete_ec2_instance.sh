#!/bin/bash

# stop ec2 instances
aws ec2 stop-instances --instance-ids $INSTANCE_ID
sleep 10

# delete ec2 instances
aws ec2 terminate-instances --instance-ids $INSTANCE_ID
sleep 10

# delete key-pair
aws ec2 delete-key-pair --key-name $KEY_PAIR_NAME
sleep 10

# delete security-group
aws ec2 delete-security-group --group-id $SECURITY_GROUP_ID

# check if the key already exist local
if [ -f $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem ];
    then
        echo "Key $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem already exist, it will be deleted."
        rm -f $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem
    else
    echo "Key $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem not exist."
fi