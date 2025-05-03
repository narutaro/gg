# echo "# this file is located in 'src/deployment_deploy_remote_command.sh'"
# echo "# code for 'gdc deployment deploy remote' goes here"
# echo "# you can edit it freely and regenerate (it will not be overwritten)"
# inspect_args

COMPONENT_VERSION=${args[component_version]}
COMPONENT_NAME=$(yq '.componentName' $config_file)
WAIT_FLAG=${args[--wait]}

# Update component version only if COMPONENT_VERSION is specified
if [ -n "$COMPONENT_VERSION" ]; then
  log INFO "Updating component version in the deployment.yaml - $COMPONENT_VERSION"
  yq -i ".components.\"$COMPONENT_NAME\".componentVersion = \"$COMPONENT_VERSION\"" $deployment_yaml_path
else
  log INFO "COMPONENT_VERSION is not specified. Skipping update."
fi

# create-deployment
cmd1=(
  aws greengrassv2 create-deployment
  --cli-input-yaml file://$deployment_yaml_path
  --output text
)

#
# If there is a deployment name, append the last of the command
#
# DEPLOYMENT_NAME=${args[deployment_name]}
# [ -n "$DEPLOYMENT_NAME" ] && cmd1+=(--deployment-name "$DEPLOYMENT_NAME")

# Execute command
log DEBUG "Executing - ${cmd1[*]}"
DEPLOYMENT_ID=$("${cmd1[@]}") || {
  log ERROR "Failed to create deployment"
  exit 1
}
log INFO "DeploymentId: $DEPLOYMENT_ID"

cmd2=(
  aws greengrassv2 get-deployment
  --deployment-id "$DEPLOYMENT_ID"
  --output yaml
)
log DEBUG "Executing - ${cmd2[*]}"

# Wait until the deployment status will change
if [ -n "$WAIT_FLAG" ] && [ "$WAIT_FLAG" -eq 1 ]; then
  log INFO "Polling deployment status for DeploymentId - $DEPLOYMENT_ID"
  POLL_INTERVAL=5
  MAX_RETRIES=24
  retries=0
  
  while true; do
    DEPLOYMENT_STATUS=$("${cmd2[@]}" | yq '.deploymentStatus') || {
      log ERROR "Failed to retrieve deployment status"
      exit 1
    }

    log INFO "$retries: Checking deployment status - $DEPLOYMENT_STATUS"

    if [[ "$DEPLOYMENT_STATUS" != "ACTIVE" ]]; then
      # log INFO "Deployment has reached final status: $DEPLOYMENT_STATUS"
      break
    fi

    if (( retries >= MAX_RETRIES )); then
      log ERROR "Timed out waiting for deployment to complete. Last status: $DEPLOYMENT_STATUS"
      exit 1
    fi

    sleep "$POLL_INTERVAL"
    retries=$((retries + 1))
  done
fi

echo ""
"${cmd2[@]}" | yq
echo ""
