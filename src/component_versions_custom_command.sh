# echo "this file is located in 'src/component_versions_custom_command.sh'"
# echo "code for 'gg component versions custom' goes here"
# echo "you can edit it freely and regenerate (it will not be overwritten)"
# inspect_args

COMPONENT_NAME=${args[component_name]}
AWS_REGION=$(yq '.awsRegion' $config_file)
AWS_ACCOUNT=$(yq '.awsAccount' $config_file)

cmd=(
  aws greengrassv2 list-component-versions
  --arn arn:aws:greengrass:$AWS_REGION:$AWS_ACCOUNT:components:$COMPONENT_NAME
  --output yaml
)

log DEBUG "Executing - ${cmd[*]}"
echo ""
"${cmd[@]}" | yq
echo ""