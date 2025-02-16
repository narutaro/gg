# echo "# this file is located in 'src/deployment_view_command.sh'"
# echo "# code for 'gg deployment view' goes here"
# echo "# you can edit it freely and regenerate (it will not be overwritten)"
# inspect_args

TARGET_NAME=${args[target_name]}
THING_TYPE=$(get_thing_type $TARGET_NAME) || exit 1
AWS_REGION=$(yq '.awsRegion' $config_file)
AWS_ACCOUNT=$(yq '.awsAccount' $config_file)

#aws greengrassv2 get-deployment --deployment-id 21a5f908-e954-41b6-af2f-4c2dd78ddc7c --output yaml

TARGET_ARN=arn:aws:iot:$AWS_REGION:$AWS_ACCOUNT:$THING_TYPE/$TARGET_NAME

cmd1=(
  aws greengrassv2 list-deployments 
  --target-arn $TARGET_ARN
  --query 'deployments[?isLatestForTarget == `true`].deploymentId'
  --output text
)

# Execute command
log DEBUG "Executing - ${cmd1[*]}"
DEPLOYMENT_ID=$("${cmd1[@]}") || {
  log ERROR "Failed fetch the deployment id for $TARGET_NAME"
  exit 1
}
log INFO "DeploymentId - $DEPLOYMENT_ID"

cmd2=(
  aws greengrassv2 get-deployment
  --deployment-id "$DEPLOYMENT_ID"
  --output yaml
)
log DEBUG "Executing - ${cmd2[*]}"

echo ""
"${cmd2[@]}" | yq
echo ""