#!/bin/bash

# variables
AWS_MACHINE_IMAGE="ami-0d1ddd83282187d18"
AWS_REGION="eu-central-1"
INSTANCE_TYPE="t2.micro"
INSTANCE_NAME="my-ec2-instance"
KEY_PAIR_NAME="id_aws"
KEY_PATH_LOCAL="/home/outside/.ssh/"
SECURITY_GROUP_NAME="my-security-group"
SECURITY_GROUP_DESCRIPTION="My security group"

# create vpc
VPC_ID=$(aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --query 'Vpc.VpcId' \
    --output text) && \
echo "- vpc added successfully $VPC_ID"

# crate subnet
SUBNET_ID=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block 10.0.1.0/24 \
    --query 'Subnet.SubnetId' \
    --output text) && \
echo "- subnet addes successfully $SUBNET_ID"

# create gateway
GATEWAY_ID=$(aws ec2 create-internet-gateway \
    --query InternetGateway.InternetGatewayId \
    --output text) && \
echo "- gateway addes successfully $GATEWAY_ID"

# add gateway to vpc
aws ec2 attach-internet-gateway \
    --vpc-id $VPC_ID \
    --internet-gateway-id $GATEWAY_ID

# create route table
ROUTE_TABLE_ID=$(aws ec2 create-route-table \
    --vpc-id vpc-2f09a348 \
    --query RouteTable.RouteTableId \
    --output text) && \
echo "- added route table successfully $ROUTE_TABLE_ID"

# add a route to route table
aws ec2 create-route \
    --route-table-id $ROUTE_TABLE_ID \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id $GATEWAY_ID

echo "Wait 5 seconds"
BAR='#####'
for i in {1..5}; do
    echo -ne "\r${BAR:0:$i}"
    sleep 1                 
done

# check route table
aws ec2 describe-route-tables \ 
    --route-table-id $ROUTE_TABLE_ID


# check if the key already exist local
if [ -f $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem ];
    then
        echo "- Key already exist local, it will be deleted."
        rm -f $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem
fi

# create key-pair and save the privateKey local
KEY_ID=$(aws ec2 create-key-pair \
    --region $AWS_REGION \
    --key-name $KEY_PAIR_NAME \
    --query 'KeyMaterial' \
    --output text > $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem) && \
echo "- key added successfully $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem"

# change private-key permission
chmod 400 $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem

# create security-group
SECURITY_GROUP_ID=$(aws ec2 create-security-group \
    --group-name "$SECURITY_GROUP_NAME" \
    --description "$SECURITY_GROUP_DESCRIPTION" \
    --query 'GroupId' \
    --output text) && \
echo "- security group created with ID: $SECURITY_GROUP_ID"

# add inbound rules
SECURITY_GROUP_ROULE_ID=$(aws ec2 authorize-security-group-ingress \
    --group-id $SECURITY_GROUP_ID \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0 \
    --query 'SecurityGroupRules[0].SecurityGroupRuleId' \
    --output text) && \
echo "- security roule created with ID: $SECURITY_GROUP_ROULE_ID"

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
echo -e "- instance launched with ID: $INSTANCE_ID\n\nWait 30 seconds for ssh connection information"

BAR='##############################'
for i in {1..30}; do
    echo -ne "\r${BAR:0:$i}"
    sleep 1                 
done

INSTANCE_IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --query "Reservations[0].Instances[0].PublicIpAddress" --output text) && \
echo -e "\n\n* * * * * * * * * * * * * * * *\nssh -i $KEY_PATH_LOCAL$KEY_PAIR_NAME.pem ubuntu@$INSTANCE_IP\n* * * * * * * * * * * * * * * *\n" 