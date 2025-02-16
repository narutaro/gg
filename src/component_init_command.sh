# echo "# this file is located in 'src/component_init_command.sh'"
# echo "# code for 'gdc component init' goes here"
# echo "# you can edit it freely and regenerate (it will not be overwritten)"
# inspect_args

COMPONENT_NAME=${args[component_name]}
TEMPLATE_DIR=${args[--template]}
AWS_REGION=$(aws_region)
AWS_USER=$(aws_user)
AWS_ACCOUNT=$(aws_account)

# Validate component name
check_component_name $COMPONENT_NAME

# Create project files and folders
mkdir -p $COMPONENT_NAME/$src_dir_path
mkdir -p $COMPONENT_NAME/$artifacts_dir_path
mkdir -p $COMPONENT_NAME/$recipes_dir_path
mkdir -p $COMPONENT_NAME/$deployment_dir_path
touch $COMPONENT_NAME/$config_file

log DEBUG "Initializeing component - $COMPONENT_NAME"

# Create component S3 bucket
S3_BUCKET_PREFIX=$(od -An -N8 -tx1 /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
S3_BUCKET_NAME=greengrass-component-$COMPONENT_NAME-$S3_BUCKET_PREFIX

log DEBUG "Creating S3 bucket to store artifacts - $S3_BUCKET_NAME"
cmd=(
  aws s3api create-bucket
  --bucket "$S3_BUCKET_NAME"
  --region "$AWS_REGION"
  --create-bucket-configuration "LocationConstraint=$AWS_REGION"
  --output text
)
log DEBUG "Executing - ${cmd[*]}"

# Set context values in the config.yaml
yq -i ".awsRegion = \"$AWS_REGION\"" $COMPONENT_NAME/$config_file
yq -i ".awsAccount = \"$AWS_ACCOUNT\"" $COMPONENT_NAME/$config_file
yq -i ".awsUser = \"$AWS_USER\"" $COMPONENT_NAME/$config_file
yq -i ".componentName = \"$COMPONENT_NAME\"" $COMPONENT_NAME/$config_file
yq -i ".s3BucketName = \"$S3_BUCKET_NAME\"" $COMPONENT_NAME/$config_file


# Execute command
S3_ARTIFACT_URI=$("${cmd[@]}")
if [ -z "$S3_ARTIFACT_URI" ]; then
  log ERROR "Failed to create S3 bucket. Check AWS CLI configuration."
  exit 1
fi
log DEBUG "S3 URL - $S3_ARTIFACT_URI"

#
# Init with template recipe and artifact
#

# Locate template dir path
TEMPLATE_DIR_FULL_PATH=$(dirname "$(which "$command_name")")/$template_dir_path/$TEMPLATE_DIR
log DEBUG "Template directory full path - $TEMPLATE_DIR_FULL_PATH"

# Copy template files in the project dir
log DEBUG "Copying recipe.yaml to $COMPONENT_NAME/$recipe_yaml_path"
cp $TEMPLATE_DIR_FULL_PATH/recipe/recipe.yaml $COMPONENT_NAME/$recipe_yaml_path
log DEBUG "Copying files in src to $COMPONENT_NAME/$src_dir_path"
cp $TEMPLATE_DIR_FULL_PATH/src/* $COMPONENT_NAME/$src_dir_path/

# Update the template in the project dir.
if [[ "$OSTYPE" == "darwin"* ]]; then
  log DEBUG "OS Type - $OSTYPE"
  sed -i '' \
    -e "s|AUTHOR_NAME|$AWS_USER|g" \
    -e "s|S3_BUCKET_NAME|$S3_BUCKET_NAME|g" \
    -e "s|COMPONENT_NAME|$COMPONENT_NAME|g" \
    "$COMPONENT_NAME/$recipe_yaml_path"
else
  log DEBUG "OS Type - $OSTYPE"
  sed -i \
    -e "s|AUTHOR_NAME|$AWS_USER|g" \
    -e "s|S3_BUCKET_NAME|$S3_BUCKET_NAME|g" \
    -e "s|COMPONENT_NAME|$COMPONENT_NAME|g" \
    "$COMPONENT_NAME/$recipe_yaml_path"
fi

log INFO "$COMPONENT_NAME initialized"