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
    --vpc-id $VPC_ID \
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
echo "\n"