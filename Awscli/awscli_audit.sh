
#!/bin/bash

# Create output directory
mkdir -p ~/awscli_audit_results
cd ~/awscli_audit_results

echo "[+] Gathering IAM Info..."
aws iam list-users > iam_users.json
aws iam list-roles > iam_roles.json
aws iam list-policies --scope Local > iam_policies.json
aws iam get-account-authorization-details > iam_authorization_details.json

echo "[+] Gathering EC2 Network Info..."
aws ec2 describe-security-groups > ec2_security_groups.json
aws ec2 describe-network-acls > ec2_network_acls.json
aws ec2 describe-vpcs > ec2_vpcs.json
aws ec2 describe-route-tables > ec2_route_tables.json

echo "[+] Gathering S3 Info..."
aws s3api list-buckets > s3_buckets.json
for bucket in $(aws s3api list-buckets --query "Buckets[].Name" --output text); do
    aws s3api get-bucket-acl --bucket $bucket > "s3_acl_$bucket.json"
done

echo "[+] Gathering CloudTrail Info..."
aws cloudtrail describe-trails > cloudtrail_trails.json
for trail in $(aws cloudtrail describe-trails --query "trailList[].Name" --output text); do
    aws cloudtrail get-trail-status --name $trail > "cloudtrail_status_$trail.json"
done

echo "[+] Gathering General Inventory..."
aws ec2 describe-instances > ec2_instances.json
aws rds describe-db-instances > rds_instances.json
aws lambda list-functions > lambda_functions.json
aws secretsmanager list-secrets > secrets.json

echo "[+] AWS CLI audit completed. Results saved in ~/awscli_audit_results/"
