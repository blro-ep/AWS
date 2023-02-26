#!/bin/bash

# variables
AWS_MACHINE_IMAGE="ami-0d1ddd83282187d18"
AWS_REGION="eu-central-1"
INSTANCE_TYPE="t2.micro"
INSTANCE_NAME="my-ec2-instance"
INSTANCE_STATUS="running"
KEY_PAIR_NAME="id_aws"
KEY_PATH_LOCAL="/home/outside/.ssh/"
SECURITY_GROUP_NAME="my-security-group"
SECURITY_GROUP_DESCRIPTION="My security group"

INSTANCE_ID=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=$INSTANCE_NAME" "Name=instance-state-name,Values=$INSTANCE_STATUS" \
    --query "Reservations[*].Instances[*].[InstanceId]" \
    --output text) && \
echo "- found instance ID: $INSTANCE_ID"

# get security group id
SECURITY_GROUP_ID=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=$INSTANCE_NAME" "Name=instance-state-name,Values=$INSTANCE_STATUS" \
    --query "Reservations[*].Instances[*].SecurityGroups[*].[GroupId]" \
    --output text) && \
echo "- found security group ID: $SECURITY_GROUP_ID"

# stop ec2 instances
INSTANCES_STOP=$(aws ec2 stop-instances \
    --instance-ids $INSTANCE_ID \
    --query "StoppingInstances[*].CurrentState[*].[Name]" \
    --output text) 
sleep 5

# delete ec2 instances
INSTANCES_TERMINATE=$(aws ec2 terminate-instances \
    --instance-ids $INSTANCE_ID \
    --query "TerminatingInstances[*].CurrentState[*].[Name]" \
    --output text) 

if [ $? = 0 ]; then
echo "- instance $INSTANCE_ID terminated successfully"
fi    

# delete key-pair
aws ec2 delete-key-pair \
    --key-name $KEY_PAIR_NAME

if [ $? = 0 ]; then
echo "- key $KEY_PAIR_NAME deleted successfully"
fi 
sleep 5

# check if the key already exist local
if [ -f $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem ];
    then
        echo "- key local $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem deleted successfully"
        rm -f $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem
fi

echo -e "\nWait 40 seconds to delet security group"
BAR='#############################################'
for i in {1..45}; do
    echo -ne "\r${BAR:0:$i}"
    sleep 1                 
done

# delete security-group
aws ec2 delete-security-group --group-id $SECURITY_GROUP_ID

if [ $? = 0 ]; then
echo -e "\n\n- the security group was successfully deleted."
fi