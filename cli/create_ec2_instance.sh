#!/bin/bash

#variables
KeyPair="id_aws"
SecGroNam="my-security-group"
SecGroDes="My security group"

# key-pair erstellen und privateKey lokal speichern
aws ec2 create-key-pair --key-name $KeyPair --query 'KeyMaterial' --output text > ~/.ssh/$KeyPair.pem

# change private-key permission
chmod 400 id_aws.pem

# create security-group
aws ec2 create-security-group --group-name $SecGroNam --description $SecGroDes

# authorize-security-group-ingress
aws ec2 authorize-security-group-ingress --group-id sg-08499662d6985e9bb --protocol tcp --port 22 --cidr 0.0.0.0/24



 

