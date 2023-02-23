# key-pair
## create-key-pair 
aws ec2 create-key-pair --key-name MyKeyPair

## describe-key-pairs 
aws ec2 describe-key-pairs --key-name MyKeyPair

## delete-key-pair
aws ec2 delete-key-pair --key-name MyKeyPair

# security-group
## create-security-group
aws ec2 create-security-group --group-name MySecurityGroup --description "My security group"

## describe-security-groups
aws ec2 describe-security-groups

## delete-security-group
aws ec2 delete-security-group --group-name MySecurityGroup
or
aws ec2 delete-security-group --group-id sg-xxxxxxx

### authorize-security-group-ingress
aws ec2 authorize-security-group-ingress \
    --group-id sg-xxxxxxxxxxxxxxxxx \
    --protocol tcp \
    --port 22 \

# instances
## run-instances
aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-xxxxxxx

## describe-instances 
aws ec2 describe-instances \

### describe-instances by id
aws ec2 describe-instances \
    --instance-ids i-1234567890abcdef0

## stop-instances
aws ec2 stop-instances --instance-ids i-xxxxxxxxxxxxxxxx

## terminate-instances
aws ec2 terminate-instances --instance-ids i-xxxxxxxxxxxxxxxx

