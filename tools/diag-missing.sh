#!/usr/bin/env bash
# Why are the VPC / VM / SageMaker domain missing? Shows real errors and searches all regions.
ID="${DEPLOYMENT_ID:-$(aws s3api list-buckets --query "Buckets[?starts_with(Name,'psb-lab-')].Name" --output text | tr '\t' '\n' | head -1 | sed 's/psb-lab-//')}"
export AWS_PAGER=""; R=ap-southeast-1
echo "Deployment ID: $ID"
echo; echo "=== 1. Raw API results in $R (errors shown, not hidden) ==="
for c in "ec2 describe-vpcs --query Vpcs[].[VpcId,IsDefault,Tags[?Key=='Name']|[0].Value] --output text" \
         "ec2 describe-instances --query Reservations[].Instances[].[InstanceId,State.Name,Tags[?Key=='Name']|[0].Value] --output text" \
         "ec2 describe-key-pairs --query KeyPairs[].KeyName --output text" \
         "sagemaker list-domains --query Domains[].[DomainName,Status] --output text" \
         "cloudformation describe-stacks --query Stacks[].[StackName,StackStatus] --output text"; do
  echo "--- aws $c"; aws --region $R $c 2>&1 | head -15
done
echo; echo "=== 2. Bucket tags (shows which stack created it) ==="
aws s3api get-bucket-tagging --bucket "psb-lab-$ID" --output text 2>&1
STACK=$(aws s3api get-bucket-tagging --bucket "psb-lab-$ID" --query "TagSet[?Key=='aws:cloudformation:stack-name'].Value" --output text 2>/dev/null)
if [ -n "$STACK" ] && [ "$STACK" != "None" ]; then
  echo; echo "=== 3. Stack $STACK status and failed events ==="
  aws --region $R cloudformation describe-stacks --stack-name "$STACK" --query "Stacks[0].[StackStatus,StackStatusReason]" --output text 2>&1
  aws --region $R cloudformation describe-stack-events --stack-name "$STACK" \
    --query "StackEvents[?contains(ResourceStatus,'FAILED')].[Timestamp,LogicalResourceId,ResourceStatus,ResourceStatusReason]" --output text 2>&1 | head -20
  aws --region $R cloudformation list-stack-resources --stack-name "$STACK" \
    --query "StackResourceSummaries[].[LogicalResourceId,ResourceStatus]" --output text 2>&1
fi
echo; echo "=== 4. Search every region for windowsvm-$ID and psb-lab-domain ==="
for r in $(aws ec2 describe-regions --query "Regions[].RegionName" --output text 2>/dev/null); do
  v=$(aws --region $r ec2 describe-instances --filters "Name=tag:Name,Values=windowsvm-$ID" --query "Reservations[].Instances[].[InstanceId,State.Name]" --output text 2>/dev/null)
  d=$(aws --region $r sagemaker list-domains --query "Domains[?DomainName=='psb-lab-domain'].[DomainId,Status]" --output text 2>/dev/null)
  [ -n "$v$d" ] && echo "  $r  VM: ${v:--}  Domain: ${d:--}"
done
echo "  (scan done)"
echo; echo "=== 5. Policies on $(aws sts get-caller-identity --query Arn --output text) ==="
U=$(aws sts get-caller-identity --query Arn --output text | awk -F/ '{print $NF}')
aws iam list-attached-user-policies --user-name "$U" --query "AttachedPolicies[].PolicyName" --output text 2>&1
aws iam list-user-policies --user-name "$U" --query PolicyNames --output text 2>&1
aws iam list-groups-for-user --user-name "$U" --query "Groups[].GroupName" --output text 2>&1
