# echo "# this file is located in 'src/component_push_command.sh'"
# echo "# code for 'gdc component push' goes here"
# echo "# you can edit it freely and regenerate (it will not be overwritten)"
# inspect_args
COMPONENT_VERSION=${args[component_version]}
COMPONENT_NAME=$(yq ".componentName" $config_file) 
COMPONENT_S3_BUCKET=$(yq ".s3BucketName" $config_file) 

cmd=(
  aws s3 cp
  $artifacts_dir_path/$COMPONENT_NAME/$COMPONENT_VERSION/files.zip
  s3://$COMPONENT_S3_BUCKET/artifacts/$COMPONENT_NAME/$COMPONENT_VERSION/files.zip
)

# Execute command
log DEBUG "Executing - ${cmd[*]}"
${cmd[@]} > /dev/null 2>&1

log INFO "$COMPONENT_NAME - $COMPONENT_VERSION pushed"