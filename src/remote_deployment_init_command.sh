# echo "# this file is located in 'src/deployment_init_command.sh'"
# echo "# code for 'gdc deployment init' goes here"
# echo "# you can edit it freely and regenerate (it will not be overwritten)"
# inspect_args
TARGET_NAME=${args[target_name]}
TEMPLATE_DIR=${args[--template]}
COMPONENT_NAME=$(yq '.componentName' $config_file)
AWS_REGION=$(yq '.awsRegion' $config_file)
AWS_ACCOUNT=$(yq '.awsAccount' $config_file)

TARGET_TYPE=$(get_thing_type $TARGET_NAME) || exit 1
if [ "$TARGET_TYPE" = "thing" ] || [ "$TARGET_TYPE" = "thinggroup" ]; then
  log DEBUG "The target '$TARGET_NAME' is of type '$TARGET_TYPE'."
  TARGET_ARN="arn:aws:iot:$AWS_REGION:$AWS_ACCOUNT:$TARGET_TYPE/$TARGET_NAME"
fi

log DEBUG "TARGET_ARN - $TARGET_ARN"

# TODO - get the latest component version(aws managed components) and replace the version in the yaml
#get_latest_component_version(){
#  aws greengrassv2 list-component-versions \
#  --arn arn:aws:greengrass:$AWS_REGION:$AWS_ACCOUNT:components:$COMPONENT_NAME \
#  | yq -r '.componentVersions[0].componentVersion'
#}
#log INFO "The latest component version for $COMPONENT_NAME - $LATEST_COMPONENT_VERSION"

# Locate template dir path
TEMPLATE_DIR_FULL_PATH=$(dirname "$(which "$command_name")")/$template_dir_path/$TEMPLATE_DIR
log DEBUG "Template directory full path - $TEMPLATE_DIR_FULL_PATH"

# Copy template files in the project dir
log DEBUG "Copying $TEMPLATE_DIR_FULL_PATH/deployment/deployment.yaml to $deployment_yaml_path"
cp $TEMPLATE_DIR_FULL_PATH/deployment/deployment.yaml $deployment_yaml_path

# Update deployment.yaml
log DEBUG "Updating deployment file - $deployment_yaml_path"

if [[ "$OSTYPE" == "darwin"* ]]; then
  log DEBUG "OS Type - $OSTYPE"
  sed -i '' \
    -e "s|COMPONENT_NAME|$COMPONENT_NAME|g" \
    -e "s|TARGET_ARN|$TARGET_ARN|g" \
    $deployment_yaml_path
else
  log DEBUG "OS Type - $OSTYPE"
  sed -i \
    -e "s|COMPONENT_NAME|$COMPONENT_NAME|g" \
    -e "s|TARGET_ARN|$TARGET_ARN|g" \
    $deployment_yaml_path
fi

log INFO "Deployment initialized with $deployment_yaml_path"
