# AWS Command Line Interface

## key-pair

### create-key-pair 
> aws ec2 create-key-pair --key-name MyKeyPair

[AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/ec2/create-key-pair.html)  

### describe-key-pairs 
> aws ec2 describe-key-pairs --key-name MyKeyPair

### delete-key-pair
> aws ec2 delete-key-pair --key-name MyKeyPair

## security-group
### create-security-group
> aws ec2 create-security-group --group-name MySecurityGroup --description "My security group"

### describe-security-groups
> aws ec2 describe-security-groups

[AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-security-groups.html)

#### describe-security-groups --filter --query
> aws ec2 describe-security-groups --filter Name="group-name",Values="$SecGroNam" --query "SecurityGroups[*].[GroupName]" --output text

### delete-security-group
> aws ec2 delete-security-group --group-name MySecurityGroup

> aws ec2 delete-security-group --group-id sg-xxxxxxx

#### authorize-security-group-ingress
> aws ec2 authorize-security-group-ingress \
    --group-id sg-xxxxxxxxxxxxxxxxx \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/24

[AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/ec2/authorize-security-group-ingress.html)

## instances
### run-instances
> aws ec2 run-instances --image-id ami-xxxxxxxx --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-xxxxxxx

### describe-instances 
> aws ec2 describe-instances

#### describe-instances by id
> aws ec2 describe-instances \
    --instance-ids i-xxxxxxxxxxxxxxxx

### stop-instances
> aws ec2 stop-instances --instance-ids i-xxxxxxxxxxxxxxxx

### terminate-instances
> aws ec2 terminate-instances --instance-ids i-xxxxxxxxxxxxxxxx

