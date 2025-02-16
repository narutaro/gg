# echo "# this file is located in 'src/component_versions_public_command.sh'"
# echo "# code for 'gg component versions public' goes here"
# echo "# you can edit it freely and regenerate (it will not be overwritten)"
# inspect_args

COMPONENT_NAME=${args[component_name]}
AWS_REGION=$(yq '.awsRegion' $config_file)

if [[ "$COMPONENT_NAME" != aws.greengrass.* ]]; then
  COMPONENT_NAME="aws.greengrass.$COMPONENT_NAME"
fi

cmd=(
  aws greengrassv2 list-component-versions
  --arn arn:aws:greengrass:$AWS_REGION:aws:components:$COMPONENT_NAME
  --output yaml
)

log DEBUG "Executing - ${cmd[*]}"
echo ""
"${cmd[@]}" | yq
echo ""