#echo "# this file is located in 'src/local_deployment_remove_command.sh'"
#echo "# code for 'gg local-deployment remove' goes here"
#echo "# you can edit it freely and regenerate (it will not be overwritten)"
#inspect_args
COMPONENT_NAME=$(yq '.componentName' $config_file)

cmd=(
  sudo /greengrass/v2/bin/greengrass-cli
  deployment create
  --recipeDir component/recipes/
  --remove $COMPONENT_NAME
)

log DEBUG "Removing component - $COMPONENT_NAME"
log DEBUG "Executing - ${cmd[*]}"
echo ""
"${cmd[@]}" | yq || log ERROR "Failed to parse the output with yq"
echo ""