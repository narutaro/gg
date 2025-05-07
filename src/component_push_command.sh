# echo "# this file is located in 'src/component_push_command.sh'"
# echo "# code for 'gdc component push' goes here"
# echo "# you can edit it freely and regenerate (it will not be overwritten)"
# inspect_args
COMPONENT_VERSION=${args[component_version]}
COMPONENT_NAME=$(yq ".componentName" $config_file) 
COMPONENT_S3_BUCKET=$(yq ".s3BucketName" $config_file) 

local_file="$artifacts_dir_path/$COMPONENT_NAME/$COMPONENT_VERSION/files.zip"
if [ ! -f "$local_file" ]; then
  log ERROR "Local file not found: $local_file"
  exit 1
fi

cmd=(
  aws s3 cp
  $artifacts_dir_path/$COMPONENT_NAME/$COMPONENT_VERSION/files.zip
  s3://$COMPONENT_S3_BUCKET/artifacts/$COMPONENT_NAME/$COMPONENT_VERSION/files.zip
)

# Execute command
log DEBUG "Executing - ${cmd[*]}"
#${cmd[@]} > /dev/null 2>&1
if ${cmd[@]}; then
  log INFO "$COMPONENT_NAME - $COMPONENT_VERSION pushed successfully"
else
  log ERROR "Failed to push $COMPONENT_NAME - $COMPONENT_VERSION to S3"
  exit 1
fi

