# echo "# this file is located in 'src/component_create_command.sh'"
# echo "# code for 'gdc component create' goes here"
# echo "# you can edit it freely and regenerate (it will not be overwritten)"
# inspect_args
AWS_REGION=$(yq '.awsRegion' $config_file)
AWS_ACCOUNT=$(yq '.awsAccount' $config_file)
COMPONENT_VERSION=${args[component_version]}
COMPONENT_NAME=$(yq ".componentName" $config_file) 
RECIPE_FILE_PATH=$recipes_dir_path/recipe-$COMPONENT_VERSION.yaml

log DEBUG "Using recipe - $RECIPE_FILE_PATH"

# Create component version
cmd1=(
  aws greengrassv2 create-component-version
  --inline-recipe fileb://$RECIPE_FILE_PATH
  --output yaml
)

# create-component-version
log DEBUG "Executing - ${cmd1[*]}"
echo ""
"${cmd1[@]}" | yq
echo ""

# Check the status of the create request

cmd2=(
  aws greengrassv2 describe-component
  --arn arn:aws:greengrass:$AWS_REGION:$AWS_ACCOUNT:components:$COMPONENT_NAME:versions:$COMPONENT_VERSION
  --output yaml
)
log INFO "Checking the component status"
log DEBUG "Executing - ${cmd2[*]}"
echo ""
"${cmd2[@]}" | yq
echo ""

log INFO "$COMPONENT_NAME - $COMPONENT_VERSION created"