#!/bin/bash

# variables
AWS_MACHINE_IMAGE="ami-0d1ddd83282187d18"
AWS_REGION="eu-central-1"
INSTANCE_TYPE="t2.micro"
INSTANCE_NAME="my-ec2-intance"
KEY_PAIR_NAME="id_aws"
KEY_PATH_LOCAL="/home/outside/.ssh/"
SECURITY_GROUP_NAME="my-security-group"
SECURITY_GROUP_DESCRIPTION="My security group"

# check if the key already exist local
if [ -f $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem ];
    then
        echo "Key already exist, it will be deleted."
        rm -f $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem
    else
    echo "The KeyPair will be created."
fi

# create key-pair and save the privateKey local
KEY_ID=$(aws ec2 create-key-pair \
    --region $AWS_REGION \
    --key-name $KEY_PAIR_NAME \
    --query 'KeyMaterial' \
    --output text > $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem) && \
echo "added Key $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem"

# change private-key permission
chmod 400 $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem

# create security-group
SECURITY_GROUP_ID=$(aws ec2 create-security-group \
    --group-name "$SECURITY_GROUP_NAME" \
    --description "$SECURITY_GROUP_DESCRIPTION" \
    --query 'GroupId' \
    --output text) && \
echo "Security group created with id $SECURITY_GROUP_ID"

# add inbound rules
aws ec2 authorize-security-group-ingress \
    --group-id $SECURITY_GROUP_ID \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0 \

# create ec2 instance
INSTANCE_ID=$(aws ec2 run-instances \
    --region $AWS_REGION \
    --image-id $AWS_MACHINE_IMAGE \
    --count 1 \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_PAIR_NAME \
    --security-group-ids $SECURITY_GROUP_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
    --query 'Instances[0].InstanceId' \
    --output text) && \
echo "Instance launched with id $INSTANCE_ID"

INSTANCE_IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query "Reservations[0].Instances[0].PublicIpAddress" --output text) && \
echo -e "EC2 instance $INSTANCE_NAME IP: $INSTANCE_IP \n \
      ssh -i $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem ubuntu@$INSTANCE_IP" 

