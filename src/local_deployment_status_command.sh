#echo "# this file is located in 'src/local_deployment_status_command.sh'"
#echo "# code for 'gg local-deployment status' goes here"
#echo "# you can edit it freely and regenerate (it will not be overwritten)"
#inspect_args

DEPLOYMENT_ID=${args[deployment_id]}

cmd=(
  sudo /greengrass/v2/bin/greengrass-cli
  deployment status -i $DEPLOYMENT_ID
)

log DEBUG "Executing - ${cmd1[*]}"

RESULT=$("${cmd[@]}" 2>&1) 
echo ""
echo "$RESULT" | yq || log ERROR "Failed to parse the output with yq: $RESULT"
echo ""