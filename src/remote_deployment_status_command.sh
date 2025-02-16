#echo "# this file is located in 'src/deployment_status_command.sh'"
#echo "# code for 'gdc deployment status' goes here"
#echo "# you can edit it freely and regenerate (it will not be overwritten)"
#inspect_args
DEPLOYMENT_ID=${args[deployment_id]}

# get-deployment
cmd2=(
  aws greengrassv2 get-deployment
  --deployment-id "$DEPLOYMENT_ID"
  --output yaml
)

# Execute command
log DEBUG "Executing - ${cmd2[*]}"

echo ""
"${cmd2[@]}" | yq
echo ""