#!/bin/bash

# Replace these with your own values
DB_INSTANCE_IDENTIFIER="my-postgres-db"
DB_NAME="mydatabase"
DB_USER="dbuser"
DB_PASSWORD="YourStrongPassword!" # Use a strong password!
DB_INSTANCE_CLASS="db.t3.micro" # Instance size
ALLOCATED_STORAGE="20" # Storage in GB
ALLOCATED_STORAGE="20" # Storage in GB
AVAILABILITY_ZONE="eu-west-1a" # Change to your preferred AZ
VPC_ID="vpc-093138f9f6ff8a5a7321" # Your VPC ID
SUBNET_1="subnet-0613e01e3b6c24ac4321" # Your Subnet ID
SUBNET_2="subnet-0c7c2df0db26b5d44321" # Your other Subnet ID
#YOUR_IP="82.42.0.0/32" # Replace with your public IP address. You can look up "what is my ip" on google.
# Get your public IP address (CloudShell specific)
YOUR_IP=$(curl -s http://checkip.amazonaws.com/)/32

# 1. Create Security Group
SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name rds-access-group --description "Allow access to RDS from my laptop" --vpc-id $VPC_ID --output text --query 'GroupId')

aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --cidr $YOUR_IP --protocol tcp --port 5432

# 2. Create RDS Subnet Group
aws rds create-db-subnet-group --db-subnet-group-name my-db-subnet-group --db-subnet-group-description "Subnet group for my RDS instance" --subnet-ids $SUBNET_1 $SUBNET_2

# 3. Create RDS Instance
aws rds create-db-instance \
    --db-instance-identifier $DB_INSTANCE_IDENTIFIER \
    --db-name $DB_NAME \
    --engine postgres \
    --db-instance-class $DB_INSTANCE_CLASS \
    --allocated-storage $ALLOCATED_STORAGE \
    --master-username $DB_USER \
    --master-user-password $DB_PASSWORD \
    --vpc-security-group-ids $SECURITY_GROUP_ID \
    --db-subnet-group-name my-db-subnet-group \
    --availability-zone $AVAILABILITY_ZONE \
    --publicly-accessible
