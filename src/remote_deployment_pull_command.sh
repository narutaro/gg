# echo "# this file is located in 'src/deployment_pull_command.sh'"
# echo "# code for 'gdc deployment pull' goes here"
# echo "# you can edit it freely and regenerate (it will not be overwritten)"
# inspect_args

# This command uses list-deployments. See list-effective-deployments for your reference. 
TARGET_NAME=${args[target_name]}
THING_TYPE=$(get_thing_type $TARGET_NAME)
AWS_REGION=$(yq '.awsRegion' $config_file)
AWS_ACCOUNT=$(yq '.awsAccount' $config_file)

# Get DeploymentId of the latest deployment 
cmd1=(
  aws greengrassv2 list-deployments
  --target-arn "arn:aws:iot:$AWS_REGION:$AWS_ACCOUNT:$THING_TYPE/$TARGET_NAME"
  --query 'deployments[?isLatestForTarget==`true`]'
  --output yaml
)

log DEBUG "Executing - ${cmd1[*]}"

# "${cmd[@]}" | yq
DEPLOYMENT_ID=$("${cmd1[@]}" | yq '.[0].deploymentId')
log INFO "Deployment ID: $DEPLOYMENT_ID"

# Get deployment with the DeploymentId
cmd2="aws greengrassv2 get-deployment \
--deployment-id $DEPLOYMENT_ID \
--output yaml"

DEPLOYMENT=$($cmd2)
log DEBUG "Pulling the latest deployment:"
yq <<< "$DEPLOYMENT"

# Check revisionId
REVISION_ID=$(yq '.revisionId' <<< "$DEPLOYMENT")
log DEBUG "Retrieve deployment revision - $REVISION_ID"

# Pick up and save necessary parts
yq '{"components": .components, "targetArn": .targetArn}' <<< "$DEPLOYMENT" > $deployment_yaml_path
log INFO "Deployment pulled - $deployment_yaml_path"
