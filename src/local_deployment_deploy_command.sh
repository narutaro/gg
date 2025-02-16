# echo "# this file is located in 'src/deployment_deploy_local_command.sh'"
# echo "# code for 'gdc deployment deploy local' goes here"
# echo "# you can edit it freely and regenerate (it will not be overwritten)"
# inspect_args

COMPONENT_VERSION=${args[component_version]}
COMPONENT_NAME=$(yq '.componentName' $config_file)

cmd1=(
  sudo /greengrass/v2/bin/greengrass-cli
  deployment create
  --recipeDir $recipes_dir_path
  --artifactDir $artifacts_dir_path
  --merge "$COMPONENT_NAME=$COMPONENT_VERSION"
)

log DEBUG "Executing - ${cmd1[*]}"
echo ""
"${cmd1[@]}" | yq || log ERROR "Failed to parse the output with yq"
echo ""





